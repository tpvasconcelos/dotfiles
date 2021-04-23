_path_to_pygments_styles_TODO() {
  local path_to_pygments_styles
  path_to_pygments_styles="$(cd "$(dirname "$(realpath "$(command -v pygmentize)")")"/../lib/**/site-packages/pygments/styles && pwd)"
  echo "$path_to_pygments_styles"
}

dog-pygmentize() {
  pygmentize -O style=rrt "$*"
}

dog-chroma() {
   chroma --style=rrt "$*"
}

dog() {
  dog-chroma "$*"
}
