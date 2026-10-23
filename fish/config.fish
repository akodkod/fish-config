# Intro
#

function fish_greeting
  echo "Твоє життя прекрасне! Згадай про Настюшку та ваших котів 🫶"
  echo ""
end

function fish_title
  set -l cmd (status current-command)
  if test "$cmd" = fish
    echo (basename $PWD)
  else
    echo (basename $PWD) "/ $cmd"
  end
end

function ask
    codex exec --skip-git-repo-check (string join ' ' $argv)
end

function g
    grep --color=auto -i -- $argv | grep -v '[g]rep'
end

abbr -a --position anywhere G '| g'

# Variables
#

set -gx EDITOR micro
set -gx REACT_EDITOR code
if test -S "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    set -gx SSH_AUTH_SOCK "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
end

# Plugins
#

# https://github.com/franciscolourenco/done
# TODO: Add `-sender` when this issue is resolved: https://github.com/julienXX/terminal-notifier/issues/301
# set -U __done_min_cmd_duration 15000
# set -U __done_exclude '^(git (?!push|pull|fetch)|co|cl|clp|claude|copilot|ef|rs|rc|d)'
# set -U __done_notification_command 'terminal-notifier -title "$title" -message "$argv[1]"'

# https://github.com/jhillyerd/plugin-git
abbr --erase glog

# 1Password CLI
if status is-interactive; and type -q op
    op completion fish | source
end

# Aliases
#

alias spt="bun spt"

alias reload='source "$__fish_config_dir/config.fish"'
alias ef='code --wait "$__fish_config_dir/config.fish" && reload'

alias fix-pg="rm /opt/homebrew/var/postgresql@17/postmaster.pid && brew services restart postgresql@17"

alias hrun='heroku run --size=performance-m --app=production-spotter-api'

alias cdk="cd ~/Developer/Kodkod"
alias cdt="cd ~/Developer/Temp"
alias cd0="cd ~/Developer/811spotter/monorepo"
alias cd1="cd ~/Developer/811spotter/monorepo/client"
alias cd2="cd ~/Developer/811spotter/monorepo/api"
alias cd3="cd ~/Developer/811spotter/monorepo/hq"

alias c="code ."
alias cl="claude"
alias clp="CLAUDE_CONFIG_DIR=~/.claude-personal claude"

alias ro="rex window new --focus"

alias x="nlx"
alias i="ni"
alias a="ni"
alias u="nun"
alias r="nr"
alias d="r dev"
alias ds="r dev:stop"
alias t="r type-check"
alias l="r lint"
alias lf="r lint:fix"
alias tlf="mprocs \"bun lint:fix\" \"bun type-check\""
alias tlfs="mprocs \"bun lint:fix\" \"bun type-check\" \"bun spec\""
alias bunui="bun update --interactive"

alias mx="mise x --"
alias mxb="mise x -- bundle exec"
alias be="bundle exec"
alias bi="bundle install"
alias bu="bundle update"
alias bua="bundle update --all"
alias bui="bundle update-interactive --latest --only-explicit"
alias rc="rails c"
alias rr="rails routes"
alias rs="rails s -b 0.0.0.0"
alias rt="rails test"
alias ra="rubocop -a"
alias rA="rubocop -A"
alias rdm="rails db:migrate"
alias srr="srb tc && rubocop -a && rspec"

alias o="overmind"
alias os="overmind s -D -N -f Procfile.dev"
alias oe="overmind echo"
alias oq="overmind quit; or rm -f .overmind.sock"
alias ors="overmind restart"
alias ores="overmind restart"
alias ost="overmind status"
alias ostop="overmind stop"

alias gs="git stash"
alias gsp="git stash pop"
alias gst="git status -s"
alias gcmsg="git commit -m"
alias glog="git log --all --no-merges --author='$(git config user.name)' --color --pretty=format:'%Cgreen%cd%Creset %Cred%h%Creset%C(yellow)%d%Creset %s' --abbrev-commit --date=format:'%d %b %H:%M'"

alias ls="eza --group-directories-first --icons --hyperlink --all -1 --long --no-user --no-permissions"

# Initializers
#

if status is-interactive; and type -q starship
    starship init fish | source
end

set -gx SPOTTER_DUMP_DIR "$HOME/.local/share/spotter/dumps"

fish_add_path --global "$HOME/.local/bin"
fish_add_path --global "$HOME/Library/Application Support/com.superlogical.rex/RexServer/Versions/Current/Rex Server.app/Contents/MacOS"

# bun
set --export BUN_INSTALL "$HOME/.bun"
fish_add_path --global "$BUN_INSTALL/bin"

# pnpm
if not set -q PNPM_HOME
    if test (uname) = Darwin
        set -gx PNPM_HOME "$HOME/Library/pnpm"
    else
        set -gx PNPM_HOME "$HOME/.local/share/pnpm"
    end
end
fish_add_path --global "$PNPM_HOME" "$PNPM_HOME/bin"
# pnpm end

# nub
fish_add_path --global "$HOME/.nub/bin"

# Per-machine overrides (not tracked in Git).
if test -f "$__fish_config_dir/local.fish"
    source "$__fish_config_dir/local.fish"
end
