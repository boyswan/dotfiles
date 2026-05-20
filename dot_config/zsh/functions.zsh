cd_fzf() {
  cd $HOME && cd "$(fd -t d | fzf --preview="tree -L 1 {}" --bind="space:toggle-preview" --preview-window=:hidden)" && echo "$PWD" && tree -L 2
}

history_fzf() {
  local cmd
  cmd=$(fc -ln 1 | fzf --tac --no-sort)
  if [ -n "$cmd" ]; then
    eval "$cmd"
  fi
}
