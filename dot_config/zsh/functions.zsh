cd_fzf() {
  local dir

  cd "$HOME" || return
  dir=$(fd -t d . Projects | fzf --preview="tree -L 1 {}" --bind="space:toggle-preview" --preview-window=:hidden)
  if [ -n "$dir" ]; then
    cd "$dir" || return
    echo "$PWD"
    tree -L 2
  fi
}

file_fzf() {
  local file file_path dir filename

  cd "$HOME" || return
  file=$(fd -t f . Projects | fzf --preview="bat --color=always --style=numbers --line-range=:500 {}" --bind="space:toggle-preview" --preview-window=:hidden)
  if [ -n "$file" ]; then
    file_path="${file:A}"
    dir="${file_path:h}"
    filename="${file_path:t}"
    cd "$dir" || return
    echo "Changed to: $PWD"
    echo "Selected: $filename"
    "${EDITOR:-nvim}" "$filename"
  fi
}

open_fzf() {
  file_fzf "$@"
}

history_fzf() {
  local cmd
  cmd=$(fc -ln 1 | fzf --tac --no-sort)
  if [ -n "$cmd" ]; then
    eval "$cmd"
  fi
}
