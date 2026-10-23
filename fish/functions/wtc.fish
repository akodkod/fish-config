# Create a Worktrunk worktree with an optional name (put the name before options).
function wtc --description 'Create a worktree with an optional random codename'
    if contains -- --help $argv; or contains -- -h $argv
        printf '%s\n' 'Usage: wtc [NAME] [wt switch options]' '' \
            '  wtc                     # Random name, e.g. apple-cider' \
            '  wtc my-feature          # Explicit name' \
            '  wtc --base=@            # Random name from current HEAD' \
            '  wtc my-feature --base=@ # Explicit name from current HEAD' \
            '' 'Put an explicit name before any options. Uses the current repository.'
        return 0
    end

    set -l name
    if set -q argv[1]; and not string match -q -- '-*' "$argv[1]"
        set name $argv[1]
        set -e argv[1]
    else
        command git rev-parse --git-dir >/dev/null 2>&1; or begin
            echo 'wtc: run this inside a Git repository.' >&2
            return 1
        end
        set -l first apple amber autumn blue brave cedar cherry clear coral cozy \
            crisp dawn ember fern golden hazel jade lemon lunar maple mint moss \
            peach pine quiet river silver solar spruce star sunny velvet wild willow
        set -l second badger bay birch brook canyon cider cloud comet cove crane \
            creek dune falcon field finch forest fox garden grove harbor hill lake \
            lark leaf meadow moon otter owl panda peak pine pond rain ridge robin \
            shore sparrow spring stone trail valley wave willow wind wolf
        for attempt in (seq 100)
            set -l candidate (random choice $first)-(random choice $second)
            set -l existing (command git for-each-ref --format='%(refname)' \
                "refs/heads/$candidate" "refs/remotes/*/$candidate")
            or return 1
            if test (count $existing) -eq 0
                set name $candidate
                break
            end
        end
        if test -z "$name"
            echo 'wtc: could not find an unused codename; pass a name explicitly.' >&2
            return 1
        end
        printf 'Creating worktree: %s\n' "$name" >&2
    end

    wt switch --create "$name" $argv
end
