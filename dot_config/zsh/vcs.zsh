zsh_jj_functions="$ZSH_CONFIG_DIR/vcs-info"
if (( ${fpath[(I)$zsh_jj_functions]} == 0 )); then
  fpath=("$zsh_jj_functions" $fpath)
fi
unset zsh_jj_functions

autoload -Uz vcs_info

zstyle ':vcs_info:*' enable jj git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' formats ' %F{magenta}(%s %b%m%c%u)%f'
zstyle ':vcs_info:*' actionformats ' %F{magenta}(%s %b|%a%m%c%u)%f'
zstyle ':vcs_info:jj:*' formats ' %F{magenta}%i%b%f%a | %m'
zstyle ':vcs_info:jj:*' actionformats ' %F{magenta}%i%b%f%a | %m'

precmd_vcs_info() {
  vcs_info
}

if (( ${precmd_functions[(I)precmd_vcs_info]:-0} == 0 )); then
  precmd_functions+=(precmd_vcs_info)
fi
