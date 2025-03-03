TAU_ROOT="${TAU_ROOT:-${HOME}/.tau}"

_tau::mk_root_dir() {
  # Create the TAU_ROOT directory if it does not exist
  if [[ ! -d "${TAU_ROOT}" ]]; then
    mkdir "${TAU_ROOT}"
  fi
  if [[ ! -d "${TAU_ROOT}/shims" ]]; then
    mkdir "${TAU_ROOT}/shims"
  fi
}

_tau::patch_to_minor() {
  # Extract the minor version from a patch version
  #
  # Example usage:
  #
  #   $ echo "3.8.5" | _tau::patch_to_minor
  #   3.8
  #
  #   $ echo -e "3.8.5\n3.9.7\n3.10.0" | _tau::patch_to_minor
  #   3.8
  #   3.9
  #   3.10
  #
  while IFS= read -r line; do
    if [[ ! "${line}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
      log_error "The input '${line}' does not match a valid patch version number."
      return 1
    fi
    echo "${line%.*}"
  done
}
