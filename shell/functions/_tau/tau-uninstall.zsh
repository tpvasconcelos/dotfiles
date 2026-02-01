tau-uninstall() {
  # Usage: tau uninstall [--dry-run] <version>
  #
  # Uninstall a managed Python version using uv.
  #
  # Options:
  #   --dry-run     Print planned actions without making changes.
  #
  # Arguments:
  #   <version>     Python version number (major.minor or major.minor.patch).
  #
  # Examples:
  #
  #   $ tau uninstall 3.11.7
  #   [ℹ] Uninstalling Python 3.11.7
  #
  #   $ tau uninstall 3.11
  #   [ℹ] Uninstalling Python 3.11.8
  #
  #   $ tau uninstall --dry-run 3.10
  #   [ℹ] Would uninstall Python 3.10.13
  #
  local dry_run=false
  local py_version_requested=""
  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      --dry-run)
        dry_run=true
        ;;
      -*)
        log_error "Unknown option: ${1}"
        return 1
        ;;
      *)
        if [[ -n "${py_version_requested}" ]]; then
          log_error "Too many arguments. Please provide a single version."
          return 1
        fi
        py_version_requested="$1"
        ;;
    esac
    shift
  done

  if [[ -z "${py_version_requested}" ]]; then
    log_error "Missing version argument."
    return 1
  fi

  if [[ ! "${py_version_requested}" =~ ^[0-9]+\.[0-9]+(\.[0-9]+)?$ ]]; then
    log_error "The input '${py_version_requested}' does not match a valid version number. Please use the 'major.minor' or 'major.minor.patch' format."
    return 1
  fi

  local -a py_installed_versions
  py_installed_versions=("${(@f)$(tau-versions)}") || return 1

  local py_version_patch
  if [[ "${py_version_requested}" =~ ^[0-9]+\.[0-9]+$ ]]; then
    local -a minor_matches
    minor_matches=("${(@M)py_installed_versions:#${py_version_requested}.*}")
    if (( ${#minor_matches[@]} == 0 )); then
      log_error "Could not find a match for '${py_version_requested}' installed with tau."
      return 1
    fi
    if (( ${#minor_matches[@]} > 1 )); then
      log_error "Found multiple matches for '${py_version_requested}'."
      log_error "Please uninstall a specific patch version."
      return 1
    fi
    py_version_patch="${minor_matches[1]}"
  else
    if (( ${#py_installed_versions[(I)${py_version_requested}]} == 0 )); then
      log_error "Could not find a match for '${py_version_requested}' installed with tau."
      return 1
    fi
    py_version_patch="${py_version_requested}"
  fi

  if [[ "${dry_run}" == true ]]; then
    log_info "Would uninstall Python ${py_version_patch}"
    return 0
  fi

  log_info "Uninstalling Python ${py_version_patch}"
  uv python uninstall "${py_version_patch}" || return 1

  tau-rehash
}
