export def get_keybindings [] {
  [
    {
      name: alt_back
      modifier: alt
      keycode: backspace 
      mode: [emacs vi_normal vi_insert]
      event: { edit: backspaceword }
    }
    {
      name: hint_complete
      modifier: control
      keycode: char_l
      mode: [emacs vi_normal vi_insert]
      event: { send: HistoryHintComplete }
    }
    {
      name: menu_up
      modifier: control
      keycode: char_k
      mode: [emacs vi_normal vi_insert]
      event: { send: MenuUp }
    }
    {
      name: menu_down
      modifier: control
      keycode: char_j
      mode: [emacs vi_normal vi_insert]
      event: { send: MenuDown }
    }
    {
      name: menu_page_down
      modifier: control
      keycode: char_u
      mode: [emacs vi_normal vi_insert]
      event: { send: MenuPagePrevious }
    }
    {
      name: menu_page_up
      modifier: control
      keycode: char_d
      mode: [emacs vi_normal vi_insert]
      event: { send: MenuPageNext }
    }
  ]
}
