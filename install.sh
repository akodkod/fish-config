#!/usr/bin/env bash
set -euo pipefail

skip_plugins=false
case "${1:-}" in
  --skip-plugins) skip_plugins=true ;;
  -h|--help)
    echo 'Usage: ./install.sh [--skip-plugins]'
    echo 'Backs up existing settings, copies configuration, and restores Fisher plugins.'
    exit 0 ;;
  '') ;;
  *) echo "Unknown option: $1" >&2; exit 2 ;;
esac
if [ "$#" -gt 1 ]; then echo 'Too many arguments.' >&2; exit 2; fi
command -v fish >/dev/null || { echo 'Install Fish first (macOS: brew install fish).' >&2; exit 1; }
if ! "$skip_plugins"; then
  command -v curl >/dev/null || { echo 'Install curl first.' >&2; exit 1; }
fi

repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
config_root=${XDG_CONFIG_HOME:-"$HOME/.config"}
fish_dir="$config_root/fish"
mkdir -p "$config_root"
backup_dir=$(mktemp -d "$config_root/fish-backup.XXXXXX")
if [ -e "$fish_dir" ]; then cp -RL "$fish_dir" "$backup_dir/fish"; fi
if [ -e "$config_root/starship.toml" ]; then
  cp -L "$config_root/starship.toml" "$backup_dir/starship.toml"
fi
if [ -d "$config_root/micro/colorschemes" ]; then
  cp -RL "$config_root/micro/colorschemes" "$backup_dir/micro-colorschemes"
fi
echo "Backup: $backup_dir"

# Overlay only managed files; preserve local.fish, history, and universal variables.
# Merge plugin lists so installing here doesn't uninstall unrelated plugins.
mkdir -p "$fish_dir"
{
  cat "$repo_dir/fish/fish_plugins"
  if [ -f "$fish_dir/fish_plugins" ]; then cat "$fish_dir/fish_plugins"; fi
} | awk 'NF && !seen[$0]++' > "$backup_dir/merged-plugins"
while IFS= read -r -d '' file; do
  relative=${file#"$repo_dir/fish/"}
  [ "$relative" != fish_plugins ] || continue
  mkdir -p "$(dirname -- "$fish_dir/$relative")"
  rm -f "$fish_dir/$relative"
  cp "$file" "$fish_dir/$relative"
done < <(find "$repo_dir/fish" -type f -print0)
rm -f "$fish_dir/fish_plugins" "$config_root/starship.toml"
cp "$backup_dir/merged-plugins" "$fish_dir/fish_plugins"
cp "$repo_dir/starship.toml" "$config_root/starship.toml"
mkdir -p "$config_root/micro/colorschemes"
for file in "$repo_dir"/micro/colorschemes/*.micro; do
  target="$config_root/micro/colorschemes/$(basename "$file")"
  rm -f "$target"
  cp "$file" "$target"
done

if ! "$skip_plugins"; then
  bootstrap=$(mktemp)
  trap 'rm -f "$bootstrap"' EXIT
  curl --fail --silent --show-error --location \
    https://raw.githubusercontent.com/jorgebucaran/fisher/4.4.8/functions/fisher.fish \
    --output "$bootstrap"
  # A normal Fish process persists Fisher's universal-variable ownership records.
  XDG_CONFIG_HOME="$config_root" fish -c '
    source $argv[1]; or exit 1
    fisher update; or exit 1
    # Check every requested plugin: Fisher may report partial download failures.
    for plugin in (string match -rv "^\\s*(#|\$)" < $argv[2])
        contains -- $plugin $_fisher_plugins; or exit 1
    end
  ' "$bootstrap" "$backup_dir/merged-plugins" </dev/null

  # Regenerate tool-owned completions when those tools are available.
  if command -v copilot >/dev/null; then
    if copilot completion fish > "$backup_dir/copilot.fish"; then
      cp "$backup_dir/copilot.fish" "$fish_dir/completions/copilot.fish"
    fi
  fi
fi

echo 'Installed. Open a new Fish shell to load the configuration.'
echo 'Optional tools and migration notes: see README.md.'
