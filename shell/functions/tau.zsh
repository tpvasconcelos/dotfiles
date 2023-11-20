# Utilities for managing multiple python versions on a single machine

tau-latest-patch() {
  # Infer the latest patch version from a major or minor version
  #
  # This shell function takes in a single input, which should be a
  # string representation of a Python version in the format of "major",
  # "major.minor", or "major.minor.patch". Alternatively, an empty
  # string can be passed as input, in which case the latest available
  # stable version of Python will be installed.
  #
  # Usage:
  #   tau-latest-patch <version>
  #
  # Arguments:
  #   * $1 : Empty string or a valid Python version number (matching
  #          the "^$|^([0-9]+\.)?([0-9]+\.)?([0-9]+)$" regex). If an
  #          empty string is provided, it defaults to the latest
  #          stable Python version.
  #
  # Examples:
  #
  #   $ tau-latest-patch
  #   3.12.0
  #
  #   $ tau-latest-patch 2
  #   2.7.18
  #
  #   $ tau-latest-patch 3.7
  #   3.7.15
  #
  #   $ tau-latest-patch 3.10-dev
  #   [✘] The input '3.10-dev' does not match a valid version number...
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
    # The user input to this function should be a string representation of a
    # python version, matching the regular expression ^([0-9]+\.)?([0-9]+\.)?([0-9]+)$
    # Alternatively, you can pass an empty string, in which case, the latest available
    # stable version will be pulled and installed.
    # e.g. --> "2" or "3.6" or "3.8.5" or "" (empty string)
    log_error "The input '${py_version_user_input}' does not match a valid version number. Please pass a valid version number in the format of 'major', 'major.minor', or 'major.minor.patch', or leave the input empty to install the latest stable version."
    return 1
  elif [[ "${py_version_user_input}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    # If the input matches an exact patch version (e.g. "3.8.5") we'll try to
    # get this exact version number from pyenv and, therefore, won't need to
    # infer the latest patch from the major or minor version (see below)
    py_version_patch="${py_version_user_input}"
  else
    # If this condition is reached, it means the user either did not supply any
    # version (empty $py_version_user_input) or the user supplied a major or
    # minor version in $py_version_user_input. In either case, we will grab the
    # latest stable patch that matches $py_version_user_input. We do this by
    # matching the latest CPython patch available in pyenv, and ignoring dev
    # versions. See some examples below...
    # ""    --> 3.10.0 (an empty string will match the latest stable patch)
    # "2"   --> 2.7.18 (latest stable patch from major)
    # "3.9" --> 3.9.4  (latest stable patch from minor)
    py_version_patch="$(pyenv install --list | ggrep -Po '(?<= )[0-9]+\.[0-9]+\.[0-9]+' | grep "^${py_version_user_input}" | tail -n 1 | tr -d '[:space:]')"
    if [[ -z "${py_version_patch}" ]]; then
      # If $py_version_user_input is a valid Python version (regex-wise) but
      # $py_version_patch is empty, this means no match was found for
      # $py_version_user_input. Either this version does not exist
      # (e.g. "4.2.0") or it isn't available in pyenv
      log_error "Could not find a match for '${py_version_user_input}'. Are you sure this Python version exists?"
      return 1
    elif [[ ! "${py_version_patch}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
      # Something else went wrong...
      log_error "Something went wrong parsing the python version. '${py_version_patch}' does not match the right regex."
      return 1
    fi
  fi
  echo "${py_version_patch}"
}

tau-install() {
  # Install a Python version using pyenv (python-build)
  #
  # This shell function is used to install a specific version of Python
  # using the pyenv tool. The function takes in a single input, which
  # should be a string representation of a Python version in the format
  # of "major", "major.minor", or "major.minor.patch". Alternatively,
  # an empty string can be passed as input, in which case the latest
  # available stable version of Python will be installed.
  #
  # Usage:
  #   tau-install <version>
  #
  # Arguments:
  #   * $1 : Empty string or a valid Python version number (matching
  #          the "^$|^([0-9]+\.)?([0-9]+\.)?([0-9]+)$" regex). If an
  #          empty string is provided, it defaults to the latest
  #          stable Python version.
  #
  # Examples:
  #
  #   $ tau-install
  #   [ℹ] Installing Python 3.12.0
  #
  #   $ tau-install 2.7
  #   [⚠] Skipping: Python 2.7.18 is already installed.
  #
  #   $ tau-install 3.7.1
  #   [ℹ] Installing Python 3.7.1
  #   ...
  #
  #   $ tau-install 3.10-dev
  #   [✘] The input '3.10-dev' does not match a valid version number...
  #
  local py_version_user_input="${1}"
  local py_version_patch

  py_version_patch="$(tau-latest-patch "${py_version_user_input}")"

  if contains "$(pyenv versions)" "$py_version_patch"; then
    # FIXME: This assumes that you only have stable CPython versions installed
    log_warning "Skipping: Python $py_version_patch is already installed."
  else
    # TODO: Check if it's still necessary to export SDKROOT and
    #       MACOSX_DEPLOYMENT_TARGET to run `pyenv install ...`
    #       on the latest macOS versions
    # local SDKROOT MACOSX_DEPLOYMENT_TARGET
    # SDKROOT="$(xcrun --show-sdk-path)"
    # MACOSX_DEPLOYMENT_TARGET="$(sw_vers -productVersion | grep -Eo '[0-9]+\.[0-9]+')"
    # export SDKROOT
    # export MACOSX_DEPLOYMENT_TARGET
    log_info "Installing Python '${py_version_patch}'"
    pyenv install "${py_version_patch}"
  fi
}

tau-clean-pip() {
  # Upgrade build tools and uninstall all other packages
  #
  # Arguments:
  #   * $1 : A python executable (e.g. python, python3, python3.9, etc).
  #          If not provided, it defaults to 'python'.
  #
  # Examples:
  #
  #   $ tau-clean-pip
  #   [ℹ] [python] Upgrading build tools...
  #   Requirement already satisfied: pip in ~/.pyenv/versions/3.10.6/lib/python3.10/site-packages (22.3.1)
  #   Requirement already satisfied: setuptools in ~/.pyenv/versions/3.10.6/lib/python3.10/site-packages (65.5.1)
  #   Requirement already satisfied: wheel in ~/.pyenv/versions/3.10.6/lib/python3.10/site-packages (0.38.4)
  #   [ℹ] [python] Uninstalling all packages...
  #   Found existing installation: numpy 1.23.4
  #   Uninstalling numpy-1.23.4:
  #     Successfully uninstalled numpy-1.23.4
  #
  #   $ tau-clean-pip python3.7
  #   [ℹ] [python3.7] Upgrading build tools...
  #   Requirement already satisfied: pip in ~/.pyenv/versions/3.7.13/lib/python3.7/site-packages (22.3.1)
  #   Requirement already satisfied: setuptools in ~/.pyenv/versions/3.7.13/lib/python3.7/site-packages (65.5.1)
  #   Requirement already satisfied: wheel in ~/.pyenv/versions/3.7.13/lib/python3.7/site-packages (0.38.4)
  #   [⋯] [python3.7] No packages to uninstall.
  #
  local py_executable="${1:-python}"
  log_info "[$py_executable] Upgrading build tools..."
  $py_executable -m pip install --upgrade pip setuptools wheel || return 1
  pkgs_to_uninstall="$($py_executable -m pip freeze | grep -v '^pip==' | grep -v '^setuptools==' | grep -v '^wheel==' | grep -v '^-e ')"
  if [[ -n "${pkgs_to_uninstall}" ]]; then
    log_info "[$py_executable] Uninstalling all packages..."
    $py_executable -m pip uninstall -y -r <(echo "${pkgs_to_uninstall}") || return 1
  else
    log_debug "[$py_executable] No packages to uninstall."
  fi
}

tau-clean-all-pips() {
  # Run `tau-clean-pip` for all python versions installed on the system.
  #
  # Upgrade build tools and uninstall all other packages for all
  # python versions. This function iterates over the following python
  # executables: python, python3, python3.7, python3.8, python3.9, etc.
  #
  # Arguments:
  #   * <NONE>
  #
  # Examples:
  #
  #   $ tau-clean-all-pips
  #   [ℹ] [python] Upgrading build tools...
  #   ...
  #   [⋯] [python3.6] Not installed. Skipping...
  #   ...
  #   [ℹ] [python3.9] Uninstalling all packages...
  #   ...
  #   [⋯] [python3.14] Not installed. Skipping...
  #
  local py_executable pyv pkgs_to_uninstall
  for pyv in '' '3' '3.6' '3.7' '3.8' '3.9' '3.10' '3.11' '3.12' '3.13' '3.14'; do
    py_executable="python$pyv"
    if ! command -v "$py_executable" 1>/dev/null 2>&1; then
      log_debug "[$py_executable] Not installed. Skipping..."
    else
      tau-clean-pip "$py_executable"
    fi
  done
}

tau-global() {
  # TODO: document intro
  #
  # Arguments:
  #   * $1 : A valid Python minor version number, matching the regex ^[0-9]+\.[0-9]+$
  #
  # Examples:
  #
  #   $ tau-global 3.9
  #   [ℹ] Setting Python 3.9.13 as a global version
  #
  #   $ tau-global 1
  #   [✘] The input '1' does not match a valid version number.
  #
  #   $ tau-global 4.2
  #   [✘] Could not find a match for '4.2'. Are you sure this Python version exists?
  #
  # TODO: make this compatible with passing multiple minor versions as input
  local py_version_user_input="${1}"
  local py_version_patch

  if [[ ! "${py_version_user_input}" =~ ^[0-9]+\.[0-9]+$ ]]; then
    log_error "The input '${py_version_user_input}' does not match a valid version number."
    return 1
  fi
  py_version_patch="$(pyenv versions | ggrep -Po '(?<= )[0-9]+\.[0-9]+\.[0-9]+' | grep "^${py_version_user_input}" | tail -n 1 | tr -d '[:space:]')"
  if [[ -z "${py_version_patch}" ]]; then
    # If $py_version_user_input is a valid Python version (regex-wise) but
    # $py_version_patch is empty, this means no match was found for
    # $py_version_user_input. Either this version does not exist
    # (e.g. "4.2.0") or it isn't available in pyenv
    log_error "Could not find a match for '${py_version_user_input}'. Are you sure this Python version exists?"
    return 1
  elif [[ ! "${py_version_patch}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    # Something else went wrong...
    log_error "Something went wrong parsing the python version. '${py_version_patch}' does not match the right regex."
    return 1
  fi
  log_info "Setting Python ${py_version_patch} as a global version"
  pyenv global "${py_version_patch}"
}



# FIXME: This is not working!
tau_cleanup() {
  # The code bellow grabs and uninstalls all patches from the
  # inferred minor version, that are not the installed patch
  # FIXME: This assumes that you only have stable CPython versions installed

  # TODO: 1. loop through minors
  # TODO: 2. grab latest patch for minor
  # TODO: 3. delete outdated minors
  log_info "Uninstalling Python ${version_to_uninstall}"
  pyenv uninstall --force "${version_to_uninstall}"
  # TODO: 4. set latest version as global
  log_info "Setting Python ${py_version_patch} as a global python..."
  pyenv global "${py_version_patch}"

  local version_to_uninstall
  while read -r version_to_uninstall; do
    log_info "Uninstalling Python ${version_to_uninstall}"
    pyenv uninstall --force "${version_to_uninstall}"
  done < <(pyenv versions | grep -Eo "[0-9]+\.[0-9]+\.[0-9]+" | grep "$(echo "${py_version_patch}" | grep -Eo "[0-9]+\.[0-9]+")" | grep -v "${py_version_patch}")
}
