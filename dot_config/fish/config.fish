test -f /usr/share/cachyos-fish-config/cachyos-config.fish; and source /usr/share/cachyos-fish-config/cachyos-config.fish

# Oh My Posh prompt - same atomic theme as zsh and the Windows PowerShell profile (replaces CachyOS's pure prompt).
if type -q oh-my-posh
    oh-my-posh init fish --config atomic | source
end

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end
