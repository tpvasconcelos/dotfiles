get_stem() {
  # Gets the stem of a given path. It does not check if the path
  # Arguments:
  #   * $1 : path-like string
  # Examples:
  #   $ get_stem /path/to/script.sh
  #   file
  #   $ get_stem /path/to/file
  #   file
  #   $ get_stem /path/to/directory
  #   directory
  #   $ get_stem meh
  #   meh
  #   $ get_stem
  #   ✖ get_stem: No path provided!
  if [[ -z "${*}" ]]; then
    # shellcheck disable=SC2154
    log_error "${funcstack[1]}: No path provided\!"
    return 1
  else
    printf "%s" "${$(basename -- "${*}")%.*}"
  fi
}

sizeof() {
 du -hs "${*:-.}"
}