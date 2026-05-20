bindkey -s '^F' 'cd_fzf\n'
bindkey -s '^E' 'file_fzf\n'
bindkey -s '^O' 'nvim .\n'
bindkey -s '^h' 'history_fzf\n'
bindkey '^[^?' backward-kill-word
bindkey '^l' expand-or-complete
bindkey '^R' history-incremental-search-backward
bindkey -M viins '^R' history-incremental-search-backward

zmodload -i zsh/complist
bindkey -M menuselect '^K' up-line-or-history
bindkey -M menuselect '^J' down-line-or-history
bindkey -M menuselect '^U' backward-word
bindkey -M menuselect '^D' forward-word
