abspath() {
  # Converts any path to its absolute path
  #
  # Arguments:
  #   * $@ : path-like string
  echo "$(cd "$(dirname "${@}")" && pwd)/$(basename "${@}")"
}

get_stem() {
  # Gets the stem of a given path. Note that this function does *not* check if
  # the path actually exists!
  #
  # Arguments:
  #   * $1 : path-like string
  #
  # Examples:
  #
  #   $ get_stem /path/to/script.sh
  #   script
  #
  #   $ get_stem /path/to/script.min.js
  #   script.min
  #
  #   $ get_stem /path/to/file
  #   file
  #
  #   $ get_stem /path/to/directory
  #   directory
  #
  #   $ get_stem meh
  #   meh
  #
  #   $ get_stem
  #   ✖ get_stem: No path provided!
  if [[ -z "${*}" ]]; then
    # shellcheck disable=SC2154
    log_error "${funcstack[1]}: No path provided!"
    return 1
  else
    printf "%s" "${$(basename -- "${*}")%.*}"
  fi
}

sizeof() {
 du -hs "${*:-.}"
}

largest-files() {
  # Print the largest files in a directory
  #
  # Arguments:
  #   * $1 : directory (defaults to current directory)
  #   * $2 : number of files to show (defaults to 10)
  #
  # Examples:
  #
  #   $ largest-files . 3
  #   1.5G    ./path/to/bigfile
  #   1.2G    ./other/path/to/bigfile
  #   1.1G    ./other/path/to/another/bigfile
  #
  #   $ largest-files ./other 2
  #   1.2G    ./other/path/to/bigfile
  #   1.1G    ./other/path/to/another/bigfile
  local dir="${1:-.}"
  local num="${2:-10}"
  find "${dir}" -type f -exec du -h {} + | sort -rh | head -n "${num}"
}
