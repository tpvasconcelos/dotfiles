tau-versions() {
  # Usage: tau versions [--minor] [--latest] [--squash]
  #
  # Print Python versions installed in this system (via tau or uv).
  #
  # Options:
  #   --minor     Output minor versions instead of patch versions.
  #   --latest    Print only the latest version.
  #   --squash    Print versions on a single line.
  #
  # Examples:
  #
  #   $ tau versions
  #   3.8.5
  #   3.9.7
  #   3.10.0
  #
  #   $ tau versions --minor --squash
  #   3.8 3.9 3.10
  #
  #   $ tau versions --latest
  #   3.10.0
  #
  #   $ tau versions --minor --latest
  #   3.10
  #
  local minor=false
  local latest=false
  local squash=false
  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      --minor)
        minor=true
        ;;
      --latest)
        latest=true
        ;;
      --squash)
        squash=true
        ;;
      *)
        log_error "Unknown option: ${1}"
        return 1
        ;;
    esac
    shift
  done

  local py_versions
  py_versions="$(uv python list --only-installed --output-format=json | jq -r '.[].version' | sort -V)"
  if [[ "${minor}" == true ]]; then
    py_versions="$(echo "${py_versions}" | _tau::patch_to_minor)"
  fi
  if [[ "${latest}" == true ]]; then
    py_versions="$(echo "${py_versions}" | awk 'END {print $NF}')"
  fi
  if [[ "${squash}" == true ]]; then
    py_versions="$(str-replace "${py_versions}" $'\n' ' ')"
  fi
  if [[ -z "${py_versions}" ]]; then
    log_error "No Python versions found installed with tau."
    return 1
  fi
  echo "${py_versions}"
}
