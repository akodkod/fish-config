function micro --description 'Open Micro with a theme matching macOS appearance'
    set -l theme bubblegum
    if test "(defaults read -g AppleInterfaceStyle 2>/dev/null)" = Dark
        set theme monokai
    end
    command micro -colorscheme $theme $argv
end
