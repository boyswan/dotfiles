setopt PROMPT_SUBST

zsh_prompt_vi_mode=''

zsh_prompt_uses_vi_mode() {
  [[ "$(bindkey -M main '^[' 2>/dev/null)" == *'vi-cmd-mode'* ]]
}

zsh_prompt_update_vi_mode() {
  if ! zsh_prompt_uses_vi_mode; then
    zsh_prompt_vi_mode=''
    zle reset-prompt
    return
  fi

  case "$KEYMAP" in
    vicmd)
      zsh_prompt_vi_mode='%F{yellow}[N]%f '
      ;;
    viins|main)
      zsh_prompt_vi_mode='%F{green}[I]%f '
      ;;
    *)
      zsh_prompt_vi_mode=''
      ;;
  esac
  zle reset-prompt
}

zle-line-init() {
  zsh_prompt_update_vi_mode
}

zle-keymap-select() {
  zsh_prompt_update_vi_mode
}

zle -N zle-line-init
zle -N zle-keymap-select

PROMPT='${zsh_prompt_vi_mode}%F{cyan}%~%f${vcs_info_msg_0_}
%F{242}$%f '
