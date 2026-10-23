# Fish configuration

Personal Fish aliases, functions, completions, Fisher plugins, and Starship settings.

## Install on a new Mac

Install [Homebrew](https://brew.sh) first, then:

```sh
git clone https://github.com/akodkod/fish-config.git ~/Developer/Kodkod/fish-config
cd ~/Developer/Kodkod/fish-config
brew bundle --file=Brewfile
./install.sh
fish
```

The installer also works on Linux: install Fish, Git, curl, and the tools you want
with your package manager, then run `./install.sh`.

It copies files into `${XDG_CONFIG_HOME:-$HOME/.config}/fish` and installs
`starship.toml` alongside that directory. Before changing anything, it saves a
complete copy of existing Fish and Starship settings in a `fish-backup.XXXXXX`
directory and prints its path. It preserves unrelated files, `local.fish`, and
existing universal variables, and merges the existing plugin list with this one.
Keep the printed backup to restore your previous files if needed.

[Fisher](https://github.com/jorgebucaran/fisher) restores the plugins listed in
`fish/fish_plugins` and updates any existing plugins. Internet access is required.
Use `./install.sh --skip-plugins` to copy settings offline; run the normal installer
later to restore plugins. The bootstrap uses Fisher 4.4.8; plugins follow their
upstream default branches.

To make Fish your login shell, add the output of `command -v fish` to `/etc/shells`
if it isn't listed, then run `chsh -s "$(command -v fish)"`. Alternatively, select
Fish as your terminal's shell. The installer doesn't change the login shell.

## Included

- Personal greeting, title, aliases, and helpers from `config.fish`.
- `cw`: open the first VS Code workspace in the current directory.
- `gca`: stage and commit changes using Worktrunk's configured message generator.
- `wtc`: create a Worktrunk worktree with a random two-word name, or a supplied name.
- Worktrunk shell integration and `wt` / `nr` completions.
- Git abbreviations, autopair, fzf bindings, Ruby Bundler integration, and
  abbreviation tips, restored through Fisher.
- Starship settings and optional Homebrew / Vite+ path setup.

```fish
wtc                      # Random name such as apple-cider
wtc feature-name         # Explicit name
wtc --base=@             # Random name from current HEAD
cw                       # Open this directory's .code-workspace
gca                      # Stage all changes and generate a commit message
gca --dry-run            # Preview the message without committing
gca --stage=none         # Commit only staged changes
```

`gca` forwards arguments to `wt step commit`. To generate messages with Codex,
configure `[commit.generation]` in `~/.config/worktrunk/config.toml` using the
[Worktrunk Codex setup guide](https://worktrunk.dev/llm-commits/#codex).
Without a configured generator, Worktrunk uses a message based on file names.

## Machine-specific setup

Optional integrations only initialize when installed. Aliases still require the
tools they call: VS Code (`code`), Bun, pnpm, `@antfu/ni` (`ni`, `nr`, `nlx`, `nun`),
mise, Ruby/Rails, Overmind, mprocs, Heroku, Codex, Claude, Rex, and 1Password CLI.
Install the ones you use separately. The 1Password SSH socket is selected only
when it exists. Bun supplies its own completions; the installer regenerates
Copilot completions when `copilot` is available.

Project shortcuts assume repositories under `~/Developer`. The `fix-pg` alias
targets Homebrew PostgreSQL 17 on Apple Silicon. Override these on other machines.
The pnpm directory defaults to `~/Library/pnpm` on macOS and
`~/.local/share/pnpm` on Linux.

Put private environment variables and machine-specific overrides in
`~/.config/fish/local.fish` (or `$XDG_CONFIG_HOME/fish/local.fish`). It loads last
and is neither tracked nor overwritten by the installer. For example:

```fish
set -gx EDITOR vim
alias cd0='cd ~/work/monorepo'
```

Fish history, generated `fish_variables`, plugin implementation files, and
credentials are excluded. The existing Homebrew/OpenJDK paths are recreated
conditionally, rather than importing machine-specific universal-variable state.

## Update

Edit the files in this checkout, commit and push them, then run `./install.sh` to
apply them. On another machine, run `git pull --ff-only` followed by `./install.sh`.
Installed files are copies: edits made directly in `~/.config/fish` need to be
copied back into this repository before committing.
