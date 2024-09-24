tau-latest-available() {
  # Infer the latest available Python patch version from a major or
  # minor version
  #
  # This shell function takes in a single input, which should be a
  # string representation of a Python version in the format of "major",
  # "major.minor", or "major.minor.patch". Alternatively, an empty
  # string can be passed as input, in which case the latest available
  # stable version of Python will be installed.
  #
  # Usage:
  #   tau-latest-available [<version>]
  #
  # Arguments:
  #   * $1 : Empty string or a valid Python version number (matching
  #          the "^$|^([0-9]+\.)?([0-9]+\.)?([0-9]+)$" regex). If an
  #          empty string is provided, it defaults to the latest
  #          stable Python version.
  #
  # Examples:
  #
  #   $ tau-latest-available
  #   3.12.0
  #
  #   $ tau-latest-available 2
  #   2.7.18
  #
  #   $ tau-latest-available 3.7
  #   3.7.15
  #
  #   $ tau-latest-available 3.10-dev
  #   [✘] The input '3.10-dev' does not match a valid version number...
  #
  #   $ tau-latest-available 4.2.0
  #   [✘] Could not find a match for '4.2.0'. Are you sure this Python version exists?
  #
  local py_version_user_input="${1}"
  local py_version_patch

  # Note to developer --> Handy regex matches from version numbers
  # * major ("3")     --> ^[0-9]+$
  # * minor ("3.8")   --> ^[0-9]+\.[0-9]+$
  # * patch ("3.8.5") --> ^[0-9]+\.[0-9]+\.[0-9]+$
  # * any             --> ^([0-9]+\.)?([0-9]+\.)?([0-9]+)$
  # * empty str ok    --> (^$|^([0-9]+\.)?([0-9]+\.)?([0-9]+)$)

  if [[ ! "${py_version_user_input}" =~ (^$|^([0-9]+\.)?([0-9]+\.)?([0-9]+)$) ]]; then
    log_error "The input '${py_version_user_input}' does not match a valid version number. Please pass a valid version number in the format of 'major', 'major.minor', or 'major.minor.patch', or leave the input empty to install the latest stable version."
    return 1
  fi

  py_version_patch="$(pyenv install --list | ggrep -Po '(?<= )[0-9]+\.[0-9]+\.[0-9]+' | grep "^${py_version_user_input}" | tail -n 1 | tr -d '[:space:]')"
  if [[ -z "${py_version_patch}" ]]; then
    # Either this version does not exist (e.g. "4.2.0")
    # or it isn't available in pyenv yet (e.g. "3.14t-dev")
    log_error "Could not find a match for '${py_version_user_input}'. Are you sure this Python version exists?"
    return 1
  elif [[ ! "${py_version_patch}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    # This should never happen...
    log_error "[RUNTIME ERROR] Something went wrong parsing the python version. '${py_version_patch}' does not match the right regex."
    return 1
  fi
  echo "${py_version_patch}"
}
