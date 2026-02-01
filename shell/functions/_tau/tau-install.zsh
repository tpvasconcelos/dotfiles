tau-install() {
  # Usage: tau install [version]
  #
  # Install a managed Python version using uv.
  #
  # This shell function is used to install a specific version of Python
  # using the uv CLI tool. The function takes in a single input, which
  # should be a string representation of a Python version in the format
  # of "major", "major.minor", or "major.minor.patch". Alternatively,
  # an empty string can be passed as input, in which case the latest
  # available stable version of Python will be installed.
  #
  # Arguments:
  #   [version]   Optional valid Python version number (major, major.minor, or
  #               major.minor.patch). Defaults to the latest stable version when
  #               omitted.
  #
  # Examples:
  #
  #   $ tau install
  #   [ℹ] Installing Python 3.12.0
  #
  #   $ tau install 2.7
  #   [⚠] Skipping: Python 2.7.18 is already installed.
  #
  #   $ tau install 3.7.1
  #   [ℹ] Installing Python 3.7.1
  #   ...
  #
  #   $ tau install 3.10-dev
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
  # Usage: tau install-multi [--dry-run] <version> [version ...]
  #
  # Install multiple Python versions in parallel.
  # See `tau install` for more details on version specification.
  #
  # Options:
  #   --dry-run     Print what would be installed without making changes.
  #
  # Arguments:
  #   <version>     One or more Python version numbers (major, major.minor,
  #                 or major.minor.patch). If no versions are provided, the
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
