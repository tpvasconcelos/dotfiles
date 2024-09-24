_tau::validate_preferred() {
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

_tau::unset_preferred() {
  if [[ -f "${_TAU_PREFERRED}" ]]; then
    rm "${_TAU_PREFERRED}"
  fi
}

_tau::get_preferred() {
  if [[ ! -f "${_TAU_PREFERRED}" ]]; then
    log_error "${_TAU_PREFERRED} is not set"
    return 1
  fi
  local tau_preferred
  tau_preferred="$(cat "${_TAU_PREFERRED}")"
  if ! _tau::validate_preferred "${tau_preferred}"; then
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
  #
  local tau_preferred="${1}"
  _tau::validate_preferred "${tau_preferred}" || return 1

  if [[ ! -f "${_TAU_PREFERRED}" ]]; then
    log_info "Setting Python ${tau_preferred} as the preferred Python 3 version"
  else
    local current_preferred
    current_preferred="$(_tau::get_preferred)"
    if [[ "${current_preferred}" == "${tau_preferred}" ]]; then
      log_info "Python ${tau_preferred} is already the preferred Python 3 version"
      return 0
    fi
    log_info "Changing the preferred Python 3 version from ${current_preferred} to ${tau_preferred}"
  fi
  _tau::mk_root_dir
  echo "${tau_preferred}" >"${_TAU_PREFERRED}"
}
