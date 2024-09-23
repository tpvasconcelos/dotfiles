contains() {
  # Test if a string contains a substring
  #
  # Arguments:
  #   * $1 : string
  #   * $2 : substring
  #
  # Examples
  #   $ contains "hello world" "world"; echo $?
  #   0
  #
  #   $ contains "hello world" "bye"; echo $?
  #   1
  #
  local string substring
  string="${1}"
  substring="${2}"
  if test "${string#*"$substring"}" != "$string"; then
    return 0
  else
    return 1
  fi
}


str-replace() {
  # Replace all occurrences of a substring in a string
  #
  # Arguments:
  #   * $1 : string
  #   * $2 : substring
  #   * $3 : replacement
  #
  # Examples:
  #   $ str-replace "hello world" "world" "moon"
  #   hello moon
  #
  local string substring replacement
  string="${1}"
  substring="${2}"
  replacement="${3}"
  echo "${string//"$substring"/"$replacement"}"
}

str-strip() {
  # Strip leading and trailing whitespace from a string
  #
  # Arguments:
  #   * $1 : string
  #
  # Examples
  #   $ str-strip "  hello world  "
  #   hello world
  #
  #   # Allow reading from stdin
  #   $ echo "  hello world  " | str-strip -
  #   hello world
  #
  if [[ "${1}" == "-" ]]; then
    while IFS= read -r line; do
      echo "${line}" | xargs
    done
  else
    echo "${1}" | xargs
  fi
}
