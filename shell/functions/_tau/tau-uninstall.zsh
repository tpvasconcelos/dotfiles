tau-uninstall() {
  # Thin wrapper around `pyenv uninstall`
  #
  # Usage: tau-uninstall [-y] <version>
  #
  local pyv force
  force=""
  if [[ "$1" == "-y" ]]; then
    force="--force"; shift
  fi
  pyv="${1}"
  pyenv uninstall "${force}" "${pyv}"
}
