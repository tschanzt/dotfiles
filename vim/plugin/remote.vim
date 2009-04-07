
if !&cp && !exists(":Remote") && has("user_commands")
    command Remote :call SendToRemote()

    func SendToRemote()
        !mvim --remote-tab-silent %
        q
    endfun
endif
