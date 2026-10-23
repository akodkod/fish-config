function micro --description 'Open Micro with a theme matching macOS appearance'
    set -l theme bubblegum
    set -l appearance (defaults read -g AppleInterfaceStyle 2>/dev/null)
    if test "$appearance" = Dark
        set theme monokai
    end
    command micro -colorscheme $theme $argv
end
