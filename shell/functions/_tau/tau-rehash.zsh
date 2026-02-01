_tau::build_py_shim_body() {
  echo "#!/usr/bin/env bash"
  echo ""
    # shellcheck disable=SC2028
  echo "_red_bold() { echo -e \"\033[1;31m\$*\033[0m\"; }"
  echo ""
  echo "_red_bold \"[tau.error] It looks like you're trying to run 'python' outside of a virtual environment.\""
  echo "_red_bold \"[tau.error] Please activate a virtual environment and try again, or consider using 'uv run' instead.\""
  echo ""
  echo "exit 1"
  echo ""
}

_tau::build_pip_shim_body() {
  echo "#!/usr/bin/env bash"
  echo ""
  # shellcheck disable=SC2028
  echo "_red_bold() { echo -e \"\033[1;31m\$*\033[0m\"; }"
  echo ""
  echo "_red_bold \"[tau.error] It looks like you're trying to run 'pip' outside of a virtual environment.\""
  echo "_red_bold \"[tau.error] Please activate a virtual environment and try again, or consider using uvx for global installations.\""
  echo ""
  echo "exit 1"
  echo ""
}

_tau::write_py_shim() {
  local shim_suffix shim_name shim_dest
  shim_suffix="${1}"
  shim_name="python${shim_suffix}"
  shim_dest="${TAU_ROOT}/shims/$shim_name"
  _tau::build_py_shim_body > "${shim_dest}"
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
  # Usage: tau rehash
  #
  # Regenerate python and pip shims for all installed Python versions
  #
  local py_installed_versions py_versions pyv_minor
  _tau::mk_root_dir
  # shellcheck disable=SC2296
  py_installed_versions=("${(@s: :)"$(tau-versions --squash)"}")
  for py_versions in "${py_installed_versions[@]}"; do
    pyv_minor="$(echo "${py_versions}" | _tau::patch_to_minor)"
    _tau::write_py_shim "${pyv_minor}"
    _tau::write_pip_shim "${pyv_minor}"
  done
  # Also create shims for 'python', 'python3', 'pip', and 'pip3'
  _tau::write_pip_shim ""
  _tau::write_pip_shim "3"
  _tau::write_py_shim ""
  _tau::write_py_shim "3"
}
