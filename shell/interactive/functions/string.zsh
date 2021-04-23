contains() {
  # Test if a string contains a substring
  # Arguments:
  #   * $1 : string
  #   * $2 : substring
  # Examples
  #   $ contains "hello world" "world"; echo $?
  #   0
  #   $ contains "hello world" "bye"; echo $?
  #   1
  local string substring
  string="${1}"
  substring="${2}"
  if test "${string#*$substring}" != "$string"; then
    return 0
  else
    return 1
  fi
}
