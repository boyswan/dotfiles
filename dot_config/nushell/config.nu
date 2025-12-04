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

def --env cd_fzf [] {
  cd $env.HOME
  let dir = (fd -t d . Projects | fzf --preview="tree -L 1 {}" --bind="space:toggle-preview" --preview-window=:hidden)
  if ($dir | is-not-empty) {
    cd $dir
    print $env.PWD
    tree -L 2
  }
}

def --env file_fzf [] {
    cd $env.HOME
    let file = (fd -t f . Projects | fzf --preview="bat --color=always --style=numbers --line-range=:500 {}" --bind="space:toggle-preview" --preview-window=:hidden)
    if ($file | is-not-empty) {
        let file_path = ($file | path expand)
        let dir = ($file_path | path dirname)
        cd $dir
        print $"Changed to: ($env.PWD)"
        print $"Selected: ($file_path | path basename)"
        ^$env.EDITOR ($file_path | path basename)
    }
}

$env.EDITOR = "nvim"
$env.VISUAL = "nvim"
$env.TERMINAL = "alacritty"
$env.config = {
  hooks: {
    pre_prompt: [{ ||
      if (which direnv | is-empty) {
        return
      }

      direnv export json | from json | default {} | load-env
      if 'ENV_CONVERSIONS' in $env and 'PATH' in $env.ENV_CONVERSIONS {
        $env.PATH = do $env.ENV_CONVERSIONS.PATH.from_string $env.PATH
      }
    }]
  }
  show_banner: false,
  edit_mode: vi,
  keybindings:   [
    {
      name: cd_fzf
      modifier: control
      keycode: char_f
      mode: [emacs, vi_insert, vi_normal]
      event: { send: executehostcommand cmd: "cd_fzf" }
    }
    {
      name: file_fzf
      modifier: control
      keycode: char_e
      mode: [emacs, vi_insert, vi_normal]
      event: { send: executehostcommand cmd: "file_fzf" }
    }
    {
      name: "open_nvim_current_dir"
      modifier: control
      keycode: char_o
      mode: [emacs, vi_normal, vi_insert]
      event: {
        send: executehostcommand
        cmd: "nvim ."
      }
    }
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
use ./completions-jj.nu *
