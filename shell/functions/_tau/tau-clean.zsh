tau-clean-pip() {
  # Usage: tau clean-pip [py-exec]
  #
  # Uninstall all non-core packages for a Python executable.
  # Note that this function also keeps and upgrades pip, setuptools,
  # and wheel to the latest versions.
  #
  # Arguments:
  #   [py-exec]     Optional python executable to 'clean' (e.g. python,
  #                 python3, python3.9, etc). If not provided, it
  #                 defaults to 'python'.
  #
  # Examples:
  #
  #   $ tau clean-pip
  #   [ℹ] [python] Uninstalling all packages...
  #   Found existing installation: numpy 1.23.4
  #   Uninstalling numpy-1.23.4:
  #     Successfully uninstalled numpy-1.23.4
  #
  #   $ tau clean-pip python3.7
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
  # Usage: tau clean-all-pips
  #
  # Runs `tau clean-pip` for all python versions installed on the system.
  #
  # Upgrade build tools and uninstall all other packages for all
  # python versions. This function iterates over the following python
  # executables: python, python3, python3.7, python3.8, python3.9, etc.
  #
  # Examples:
  #
  #   $ tau clean-all-pips
  #   [ℹ] [python] Uninstalling all packages...
  #   ...
  #   [ℹ] [python3.7] No packages to uninstall.
  #   ...
  #
  local py_installed_versions py_to_uninstall pyv py_executable
  # shellcheck disable=SC2296
  py_installed_versions=("${(@s: :)"$(tau-versions --minor --squash)"}")
  py_to_uninstall=('' '3' "${py_installed_versions[@]}")
  for pyv in "${py_to_uninstall[@]}"; do
    # check if pyv is empty
    if [[ -z "${pyv}" ]]; then
      py_executable="$(uv python find)"
    else
      py_executable="$(uv python find "${pyv}")"
    fi
    if ! command -v "$py_executable" 1>/dev/null 2>&1; then
      # This should never happen!
      log_error "Unexpected error: Could not find the executable '$py_executable'."
      return 1
    else
      tau-clean-pip "$py_executable"
    fi
  done
}
