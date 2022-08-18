load() {
  # This my replacement for `source`
  # Arguments:
  #   * $* : path-like string
  local path_to_script
  path_to_script="$(abspath "${*}")"
  # shellcheck disable=SC2154
  if [[ ! "${loaded_scripts+x}" ]]; then
    log_error "Can't load $path_to_script! Something went wrong initializing this shell. The \$loaded_scripts environment variable is not set. This variable should be set in your ~/.zshenv file."
    return 1
  elif [[ ${loaded_scripts[(ie)$path_to_script]} -le ${#loaded_scripts} ]]; then
    log_error "The script '$path_to_script' has already been loaded!"
    return 1
  elif ! [[ -r "${path_to_script}" ]]; then
    log_error "Could not source '$path_to_script'. The file does not exist!"
    return 1
  fi
  # shellcheck disable=SC1090
  source "${path_to_script}"
  loaded_scripts=("${path_to_script}" "${loaded_scripts[@]}")
}
