# Utilities for managing multiple python versions on a single machine

_patch_to_minor() {
  # Extract the minor version from a patch version
  # e.g. "3.8.5" --> "3.8"
  # Example usage:
  #   $ _patch_to_minor "3.8.5"
  #   3.8
  #   $ echo "3.8.5" | _patch_to_minor -
  #   3.8
  if [[ "${1}" == "-" ]]; then
    while IFS= read -r line; do
      echo "${line%.*}"
    done
  else
    echo "${1%.*}"
  fi
}

_get_patch_installed() {
  # Get all installed patch versions of Python
  # To transform the output into an array, use the following:
  #   $ # shellcheck disable=SC2296
  #   $ arr=("${(@s: :)"$(_get_patch_installed)"}")
  str-replace "$(pyenv versions --bare)" $'\n' " "
}

_get_minor_installed() {
  # Get all installed minor versions of Python
  # To transform the output into an array, use the following:
  #   $ # shellcheck disable=SC2296
  #   $ arr=("${(@s: :)"$(_get_minor_installed)"}")
  str-replace "$(pyenv versions --bare | _patch_to_minor -)" $'\n' " "
}

_get_latest_installed_patch() {
  _get_patch_installed | sort -V | awk 'END {print $NF}'
}

_get_latest_installed_minor() {
  _get_latest_installed_patch | _patch_to_minor -
}

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
    log_info "Skipping: Python $py_version_patch is already installed."
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

  # Re-generate the shims
  tau-rehash
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
  #   [ℹ] [python] Uninstalling all packages...
  #   Found existing installation: numpy 1.23.4
  #   Uninstalling numpy-1.23.4:
  #     Successfully uninstalled numpy-1.23.4
  #
  #   $ tau-clean-pip python3.7
  #   [⋯] [python3.7] No packages to uninstall.
  #
  local py_executable pkgs_to_uninstall
  py_executable="${1:-python}"
  pkgs_to_uninstall="$($py_executable -m pip freeze | grep -v '@ file' | grep -v '^pip==' | grep -v '^setuptools==' | grep -v '^wheel==' | grep -v '^-e ')"
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
  #   [ℹ] [python] Uninstalling all packages...
  #   ...
  #   [ℹ] [python3.7] No packages to uninstall.
  #   ...
  #
  local py_installed_versions py_to_uninstall pyv py_executable
  # shellcheck disable=SC2296
  py_installed_versions=("${(@s: :)"$(_get_minor_installed)"}")
  py_to_uninstall=('' '3' "${py_installed_versions[@]}")
  for pyv in "${py_to_uninstall[@]}"; do
    py_executable="python$pyv"
    if ! command -v "$py_executable" 1>/dev/null 2>&1; then
      # This should never happen!
      log_error "Unexpected error: Could not find the executable '$py_executable'."
      return 1
    else
      tau-clean-pip "$py_executable"
    fi
  done
}

tau-global() {
  # Sets the global Python version(s) for pyenv.
  #
  # This is a simple wrapper around `pyenv global` but that accepts
  # minor version numbers as input instead of full version numbers.
  #
  # Arguments:
  #   * $@ : A (list of) valid Python minor version number(s), matching
  #          the regex following: ^[0-9]+\.[0-9]+$
  #
  # Examples:
  #
  #   $ tau-global 3.9
  #   [ℹ] Setting Python 3.9.13 as a global version
  #
  #   $ tau-global '3.9 3.11'
  #   [ℹ] Setting Python 3.9.13 as a global version
  #   [ℹ] Setting Python 3.11.2 as a global version
  #
  #   $ tau-global 1
  #   [✘] The input '1' does not match a valid version number.
  #
  #   $ tau-global '3.9 4.2'
  #   [ℹ] Setting Python 3.9.13 as a global version
  #   [✘] Could not find a match for '4.2'. Are you sure this Python version exists?
  #
  local minor_versions_input patch_versions_parsed version_minor version_patch
  IFS=" " read -rA minor_versions_input <<<"${*}"

  patch_versions_parsed=()
  for version_minor in "${minor_versions_input[@]}"; do
    version_patch="$(tau-latest-patch "${version_minor}")"
    patch_versions_parsed=("${patch_versions_parsed[@]}" "${version_patch}")
  done

  log_info "Setting the following Python version(s) as global: ${patch_versions_parsed[*]}"
  pyenv global "${patch_versions_parsed[@]}"

  # TODO: This is not needed here, right? (don't hurt for now)
  tau-rehash
}


TAU_ROOT="${TAU_ROOT:-${HOME}/.tau}"
_TAU_PREFERRED="${TAU_ROOT}/preferred.txt"

_PYENV_ROOT="${PYENV_ROOT:-${HOME}/.pyenv}"

_mktau() {
  if [[ ! -d "${TAU_ROOT}" ]]; then
    mkdir "${TAU_ROOT}"
  fi
  if [[ ! -d "${TAU_ROOT}/shims" ]]; then
    mkdir "${TAU_ROOT}/shims"
  fi
}

_validate_tau_preferred() {
  local tau_preferred="${1}"
  if [[ ! "${tau_preferred}" =~ ^3\.[0-9]+$ ]]; then
    log_error "'${tau_preferred}' does not match a valid Python 3 minor version number."
    return 1
  fi
  if ! pyenv versions --bare | grep -q "^${tau_preferred}\."; then
    log_error "'${tau_preferred}' does not match any installed Python version."
    return 1
  fi
}

_unset_tau_preferred() {
  if [[ -f "${_TAU_PREFERRED}" ]]; then
    rm "${_TAU_PREFERRED}"
  fi
}

_get_tau_preferred() {
  if [[ ! -f "${_TAU_PREFERRED}" ]]; then
    log_error "${_TAU_PREFERRED} is not set"
    return 1
  fi
  local tau_preferred
  tau_preferred="$(cat "${_TAU_PREFERRED}")"
  if ! _validate_tau_preferred "${tau_preferred}"; then
    log_error "${_TAU_PREFERRED} is corrupted... Please consider removing this file."
    return 1
  fi
  echo "${tau_preferred}"
}

tau-prefer() {
  # Configure your preferred Python 3 version
  #
  # This will results in the `python` and `python3` commands pointing to
  # the specified Python 3 version.
  #
  # Arguments:
  #   * $1 : A valid Python 3 minor version number.
  #
  # Examples:
  #
  #   $ tau-prefer 3.9
  #   [ℹ] Setting Python 3.9 as the preferred Python 3 version
  #
  #   $ tau-prefer 3.9
  #   [ℹ] Python 3.9 is already the preferred Python 3 version
  #
  #   $ tau-prefer 3.10
  #   [✘] Changing the preferred Python 3 version from 3.9 to 3.10
  #
  #   $ tau-prefer 2.7
  #   [✘] '2.7' does not match a valid Python 3 minor version number.
  #
  #   $ tau-prefer 3.10-dev
  #   [✘] '3.10-dev' does not match a valid Python 3 minor version number.
  #
  #   $ tau-prefer 3.10.2
  #   [✘] '3.10.2' does not match a valid Python 3 minor version number.
  #
  #   $ tau-prefer 3.99
  #   [✘] '3.99' does not match any installed Python version.
  local tau_preferred="${1}"
  _validate_tau_preferred "${tau_preferred}" || return 1

  if [[ ! -f "${_TAU_PREFERRED}" ]]; then
    log_info "Setting Python ${tau_preferred} as the preferred Python 3 version"
  else
    local current_preferred
    current_preferred="$(_get_tau_preferred)"
    if [[ "${current_preferred}" == "${tau_preferred}" ]]; then
      log_info "Python ${tau_preferred} is already the preferred Python 3 version"
      return 0
    fi
    log_info "Changing the preferred Python 3 version from ${current_preferred} to ${tau_preferred}"
  fi
  _mktau
  echo "${tau_preferred}" >"${_TAU_PREFERRED}"
}

_build_shim_body() {
  local pyv_patch="${1}"
  echo "#!/usr/bin/env bash"
  echo ""
  echo "exec \"${_PYENV_ROOT}/versions/${pyv_patch}/bin/python\" \"\$@\""
  echo ""
}

_write_shim() {
  local pyv_patch shim_suffix pyv_minor shim_name shim_dest
  pyv_patch="${1}"  # e.g. "3.8.5"
  shim_suffix="${2}"  # e.g. "3"
  pyv_minor="$(_patch_to_minor "${pyv_patch}")"
  shim_name="python${shim_suffix}"
  shim_dest="${TAU_ROOT}/shims/$shim_name"
  log_info "Writing shim for Python ${pyv_patch} as ${shim_name}"
  # Remember to write as executable
  _build_shim_body "${pyv_patch}" > "${shim_dest}"
  chmod +x "${shim_dest}"
}

tau-rehash() {
  local tau_preferred py_installed_versions pyv_patch pyv_minor
  _mktau
  if [[ ! -f "${_TAU_PREFERRED}" ]]; then
    # If the file does not exist, we'll default
    # to the latest installed minor version
    tau_preferred="$(_get_latest_installed_minor)"
  else
    tau_preferred="$(_get_tau_preferred)"
  fi
  # shellcheck disable=SC2296
  py_installed_versions=("${(@s: :)"$(_get_patch_installed)"}")
  for pyv_patch in "${py_installed_versions[@]}"; do
    pyv_minor="$(_patch_to_minor "${pyv_patch}")"
    _write_shim "${pyv_patch}" "${pyv_minor}"
    if [[ "${pyv_minor}" == "${tau_preferred}" ]]; then
      _write_shim "${pyv_patch}" ""
      _write_shim "${pyv_patch}" "3"
    fi
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
  # TODO: 4. detect and print out outdated virtualenvs (?)
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
