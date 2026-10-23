# Available before config.fish initializes optional commands.
for prefix in /opt/homebrew /usr/local /home/linuxbrew/.linuxbrew
    if test -x "$prefix/bin/brew"
        fish_add_path --global "$prefix/bin" "$prefix/sbin" "$prefix/opt/openjdk/bin"
        break
    end
end
