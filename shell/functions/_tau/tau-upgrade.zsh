tau-upgrade() {
  # Upgrade a Python minor version to a new patch version
  #
  # Usage: tau upgrade [--dry-run] <base_version> [<new_version>]
  #
  # Arguments:
  #   * $1 : A valid Python version number (minor or patch) pointing to
  #          the base version to upgrade.
  #   * $2 : An optional valid Python patch version number pointing to
  #          the new version to upgrade to. If not provided, the latest
  #          available patch version matching the base version's minor
  #          version will be installed.
  #
  local dry_run=false
  while true; do
      case "$1" in
          --dry-run)
              dry_run=true
              shift
              ;;
          *)
              break
              ;;
      esac
  done
  local base_version="${1}"
  local new_version="${2:-}"

  if [[ ! "$base_version" =~ (^3\.[0-9]+$|^3\.[0-9]+\.[0-9]+$) ]]; then
    log_error "The value '${base_version}' for the base_version argument does not match a valid version number. Please use the minor ('3.minor') or patch ('3.minor.patch') version number format."
    return 1
  fi
  if [[ ! "$new_version" =~ (^$|^3\.[0-9]+\.[0-9]+$) ]]; then
    log_error "The value '${new_version}' for the new_version argument does not match a valid version number. Please use the patch ('3.minor.patch') version number format or leave the input empty to install the latest available patch version."
    return 1
  fi

  # Infer the latest patch version from the base version provided
  local pyv_installed
  pyv_installed="$(tau-versions)"
  if ! contains "${pyv_installed}" "${base_version}"; then
    log_error "Could not find a match for '${base_version}' installed with tau."
    return 1
  fi
  base_version_patch="$(echo "$pyv_installed" | grep -E "^${base_version}")"
  if [[ "$(echo "${base_version_patch}" | wc -l)" -ne 1 ]]; then
    log_error "Found multiple matches for '${base_version}'."
    log_error "This should not happen since tau doesn't support multiple patch versions for the same minor version."
    log_error "Please uninstall one of the versions and try again."
    return 1
  fi

  if [[ -z "${new_version}" ]]; then
    if [[ "${base_version}" =~ ^3\.[0-9]+$ ]]; then
      new_version="${base_version}"
    else
      new_version="${base_version%.*}"
    fi
  fi
  new_version_patch="$(tau-latest-available "${new_version}")"
  if [[ -z "${new_version_patch}" ]]; then
    log_error "Looks like the new_version provided ('${new_version}') is not available with uv."
    return 1
  fi

  # Check if the new version is already installed
  if contains "${pyv_installed}" "${new_version_patch}"; then
    log_info "Skipping: No upgrade needed. Python ${new_version_patch} is already installed."
    return 0
  fi

  if [[ "${dry_run}" == true ]]; then
    log_info "Would uninstall Python ${base_version_patch} and install Python ${new_version_patch}"
    return 0
  fi

  log_info "Uninstalling Python ${base_version_patch}"
  uv python uninstall "${base_version_patch}"

  log_info "Installing Python ${new_version_patch}"
  tau-install "${new_version_patch}"
}

tau-autoupgrade() {
  # Upgrade all installed Python versions to the latest patch version
  #
  # Usage: tau autoupgrade [--dry-run] [-y|--yes]
  #
  local pyv_installed pyv_patch
  pyv_installed=("${(@s: :)"$(tau-versions --squash)"}")
  (
  for pyv_patch in "${pyv_installed[@]}"; do
      (
        tau-upgrade "$@" "${pyv_patch}"
      ) &
    done
    wait
  )
}
