get_stem() {
  # Gets the stem of a given path. Note that this function does *not* check if
  # the path actually exists!
  # Arguments:
  #   * $1 : path-like string
  # Examples:
  #   $ get_stem /path/to/script.sh
  #   script
  #   $ get_stem /path/to/script.min.js
  #   script.min
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