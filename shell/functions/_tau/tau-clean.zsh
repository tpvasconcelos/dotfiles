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
  py_installed_versions=("${(@s: :)"$(tau-versions --minor --squash)"}")
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

# FIXME: This is not working!
_tau::cleanup() {
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
