alias vim = nvim
alias s = nu scripts.nu
alias j = just
alias jl = just --list
alias l = ls 
alias f = fzf 
alias k = kubectl 
alias dc = docker compose
alias z = zellij
alias gs = git status
alias gb = git branch 
alias gp = git push 
alias ga = git add 
alias gco = git checkout 
alias gc = git commit -m
alias lg = lazygit
alias tp = telepresence
alias nb = sudo nixos-rebuild switch --flake ~/Projects/nixos-config/#jack_vm

$env.EDITOR = "nvim"
$env.VISUAL = "nvim"
$env.TERMINAL = "alacritty"
$env.config = {
  show_banner: false,
  edit_mode: vi,
  keybindings:   [
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

use ~/.cache/starship/init.nu
