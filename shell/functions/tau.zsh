tau-install() {
  # Arguments:
  #   * $1 : Empty string or a valid Python version number,
  #          matching the regex (^$|^([0-9]+\.)?([0-9]+\.)?([0-9]+)$)
  # Examples:
  #   $ tau-install
  #   [ℹ] Installing Python 3.9.4
  #   $ tau-install 2.7
  #   [⚠] Skipping: Python 2.7.18 is already installed.
  #   $ tau-install 3.7.1
  #   [ℹ] Installing Python 3.7.1
  #   $ tau-install 3.10-dev
  #   [✘] The input '3.10-dev' doesnt match the a valid version number.
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
    log_error "The input '${py_version_user_input}' doesnt match the a valid version number."
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
    py_version_patch="$(pyenv install --list | ggrep -Po "(?<= )[0-9]+\.[0-9]+\.[0-9]+" | grep "^${py_version_user_input}" | tail -n 1 | xargs)"
    if [[ -z "${py_version_patch}" ]]; then
      # If $py_version_user_input is a valid Python version (regex-wise) but
      # $py_version_patch is empty, this means no match was found for
      # $py_version_user_input. Either this version does not exist
      # (e.g. "4.2.0") or it isn't available in pyenv
      log_error "Could not find a match for '${py_version_user_input}'. Are you sure this Python version exists?"
      return 1
    elif [[ ! "${py_version_patch}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
      # Something else went wrong...
      log_error "Something went wrong parsing the python version. '${py_version_patch}' doesnt match the right regex."
      return 1
    fi
  fi

  if contains "$(pyenv versions)" "$py_version_patch"; then
    # FIXME: This assumes that you only have stable CPython versions installed
    log_warning "Skipping: Python $py_version_patch is already installed."
  else
    # FIXME: Check if it's still necessary to export SDKROOT and MACOSX_DEPLOYMENT_TARGET to run `pyenv install ...`
    local SDKROOT MACOSX_DEPLOYMENT_TARGET
    SDKROOT="$(xcrun --show-sdk-path)"
    MACOSX_DEPLOYMENT_TARGET="$(sw_vers -productVersion | grep -Eo '[0-9]+\.[0-9]+')"
    export SDKROOT
    export MACOSX_DEPLOYMENT_TARGET
    log_info "Installing Python '${py_version_patch}'"
    pyenv install "${py_version_patch}"
  fi
}

tau-global() {
  # FIXME: make this compatible with passing multiple minor versions as input
  # Arguments:
  #   * $1 : A valid Python minor version number, matching the regex ^[0-9]+\.[0-9]+$
  # Examples:
  #   $ tau-global 3.9
  #   [ℹ] Setting Python 3.9.13 as a global version
  #   $ tau-global 1
  #   [✘] The input '1' doesnt match the a valid version number.
  #   $ tau-global 4.2
  #   [✘] Could not find a match for '4.2'. Are you sure this Python version exists?
  local py_version_user_input="${1}"
  local py_version_patch

  if [[ ! "${py_version_user_input}" =~ ^[0-9]+\.[0-9]+$ ]]; then
    log_error "The input '${py_version_user_input}' doesnt match the a valid version number."
    return 1
  fi
  py_version_patch="$(pyenv versions | ggrep -Po "(?<= )[0-9]+\.[0-9]+\.[0-9]+" | grep "^${py_version_user_input}" | tail -n 1 | xargs)"
  if [[ -z "${py_version_patch}" ]]; then
    # If $py_version_user_input is a valid Python version (regex-wise) but
    # $py_version_patch is empty, this means no match was found for
    # $py_version_user_input. Either this version does not exist
    # (e.g. "4.2.0") or it isn't available in pyenv
    log_error "Could not find a match for '${py_version_user_input}'. Are you sure this Python version exists?"
    return 1
  elif [[ ! "${py_version_patch}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    # Something else went wrong...
    log_error "Something went wrong parsing the python version. '${py_version_patch}' doesnt match the right regex."
    return 1
  fi
  log_info "Setting Python ${py_version_patch} as a global version"
  pyenv global "${py_version_patch}"
}

tau-install-all() {
  # TODO:
  # Arguments:
  #   * <NONE>
  # Examples:
  #   $ tau-install-all
  #   [⋯] Collected python versions: (2.7 3.7 3.8)
  #   [ℹ] Installing Python 2.7.18
  #   [⚠] Skipping: Python 3.7.10 is already installed.
  #   [ℹ] Installing Python 3.8.6
  #   $ PYENV_TARGET_VERSIONS_OVERWRITE="3.7 3.8.5" tau-install-all
  #   [⋯] Collected python versions: (3.7 3.8.5)
  #   [⚠] Skipping: Python 3.7.10 is already installed.
  #   [ℹ] Installing Python 3.8.5
  local py_versions pyv
  if [[ -n ${PYENV_TARGET_VERSIONS_OVERWRITE+x} ]]; then
    # If the $PYENV_TARGET_VERSIONS_OVERWRITE environment variable is set,
    # parse the space-separated list into an array and store it in $py_versions
    # For instance, "2.7 3.6 3.8.5" becomes ("2.7" "3.6" "3.8.5")
    IFS=" " read -rA py_versions <<<"${PYENV_TARGET_VERSIONS_OVERWRITE}"
  else
    # else... simply fallback to the default versions in $PYENV_TARGET_VERSIONS
    py_versions=("${PYENV_TARGET_VERSIONS[@]}")
  fi
  log_debug "Collected python versions: (${py_versions[*]})"
  for pyv in "${py_versions[@]}"; do
    tau-install "${pyv}"
  done
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

# FIXME: review, fix, and cleanup
clean_core_pips() {
  local py_command pyv
  for pyv in '' '3' '3.7' '3.8' '3.9' '3.10'; do
    py_command="python$pyv"
    if ! command -v "$py_command" 1>/dev/null 2>&1; then
      log_error "$py_command does not exist"
    else
      log_info "Updating pip for: $py_command"
      $py_command -m pip install -U pip
      log_info "Uninstalling all packages under $py_command"
      $py_command -m pip uninstall -y -r <($py_command -m pip freeze)
    fi
  done
}
