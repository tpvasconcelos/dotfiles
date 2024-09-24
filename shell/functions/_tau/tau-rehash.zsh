_tau::build_py_shim_body() {
  local py_versions="${1}"
  echo "#!/usr/bin/env bash"
  echo ""
  echo "exec \"${PYENV_ROOT:-${HOME}/.pyenv}/versions/${py_versions}/bin/python\" \"\$@\""
  echo ""
}

_tau::build_pip_shim_body() {
  echo "#!/usr/bin/env bash"
  echo ""
  # shellcheck disable=SC2028
  echo "_red_bold() { echo -e \"\033[1;31m\$*\033[0m\"; }"
  echo ""
  echo "_red_bold \"[tau.error] It looks like you're trying to run 'pip' outside of a virtual environment.\""
  echo "_red_bold \"[tau.error] Please activate a virtual environment and try again, or consider using pipx for global installations.\""
  echo "_red_bold \"[tau.error] If you really need to run 'pip' globally, use 'python -m pip' instead.\""
  echo ""
}

_tau::write_py_shim() {
  local shim_suffix py_versions pyv_minor shim_name shim_dest
  shim_suffix="${1}"  # e.g. "3"
  py_versions="${2}"  # e.g. "3.8.5"
  pyv_minor="$(echo "${py_versions}" | _tau::patch_to_minor)"
  shim_name="python${shim_suffix}"
  shim_dest="${TAU_ROOT}/shims/$shim_name"
  # log_info "Writing shim for Python ${py_versions} as ${shim_name}"
  _tau::build_py_shim_body "${py_versions}" > "${shim_dest}"
  chmod +x "${shim_dest}"
}

_tau::write_pip_shim() {
  local shim_suffix shim_name shim_dest
  shim_suffix="${1}"
  shim_name="pip${shim_suffix}"
  shim_dest="${TAU_ROOT}/shims/$shim_name"
  _tau::build_pip_shim_body > "${shim_dest}"
  chmod +x "${shim_dest}"
}

tau-rehash() {
  local tau_preferred py_installed_versions py_versions pyv_minor
  _tau::mk_root_dir
  if [[ ! -f "${_TAU_PREFERRED}" ]]; then
    # If the file does not exist, we'll default
    # to the latest installed minor version
    tau_preferred="$(tau-versions --minor --latest)"
  else
    tau_preferred="$(_tau::get_preferred)"
  fi
  # shellcheck disable=SC2296
  py_installed_versions=("${(@s: :)"$(tau-versions --squash)"}")
  for py_versions in "${py_installed_versions[@]}"; do
    pyv_minor="$(echo "${py_versions}" | _tau::patch_to_minor)"
    _tau::write_py_shim "${pyv_minor}" "${py_versions}"
    _tau::write_pip_shim "${pyv_minor}"
    if [[ "${pyv_minor}" == "${tau_preferred}" ]]; then
      _tau::write_py_shim "" "${py_versions}"
      _tau::write_pip_shim ""
      _tau::write_py_shim "3" "${py_versions}"
      _tau::write_pip_shim "3"
    fi
  done
}
