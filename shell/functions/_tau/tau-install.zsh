tau-install() {
  # Install a managed Python version using uv
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

  py_version_patch="$(tau-latest-available "${py_version_user_input}")"

  if contains "$(tau-versions --squash)" "$py_version_patch"; then
    # FIXME: This assumes that you only have stable CPython versions installed
    log_info "Skipping: Python $py_version_patch is already installed."
  else
    log_info "Installing Python '${py_version_patch}'"
    uv python install "${py_version_patch}"
  fi

  # Re-generate the shims
  tau-rehash
}

tau-install-multi(){
  # Install multiple Python versions (see `tau-install`)
  #
  # Usage: tau-install-multi [--dry-run] <version> [<version> ...]
  #
  dry_run=false
  if [[ "$1" == "--dry-run" ]]; then
    dry_run=true
    shift
  fi

  local py_versions=("${(@s: :)"$(echo "$@")"}")
  log_info "Installing the following Python versions (in parallel) w/ tau: ${py_versions[*]}"
  (
    for py_version in "${py_versions[@]}"; do
      (
        if [[ "${dry_run}" == true ]]; then
          log_info "Would install Python ${py_version}"
          return 0
        fi
        tau-install "$py_version"
      ) &
    done
    wait
  )
}
