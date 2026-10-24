# Windows benzeri kelime kisayollari (fish varsayilani token/argüman bazliydi)
function fish_user_key_bindings
    bind ctrl-left backward-word
    bind ctrl-right forward-word
    bind ctrl-backspace backward-kill-word
    bind ctrl-delete kill-word
    # Ctrl+Z geri al (fish varsayilani), Ctrl+Y yinele
    bind ctrl-y redo
end
