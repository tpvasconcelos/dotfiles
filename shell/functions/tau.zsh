# Utilities for managing multiple python versions on a single machine

# shellcheck source=functions/_tau/tau-upgrade.zsh
for tau_module in "$SHELL_DIR_FUNCTIONS/_tau"/*(.); do
  source "$tau_module"
done


_tau::legacy_global() {
  # Sets the global Python version(s) for pyenv.
  #
  # This is a simple wrapper around `pyenv global` but that accepts
  # minor version numbers as input instead of full version numbers.
  #
  # Arguments:
  #   * $@ : A (list of) valid Python minor version number(s), matching
  #          the regex following: ^[0-9]+\.[0-9]+$
  #
  # Examples:
  #
  #   $ tau-global 3.9
  #   [ℹ] Setting Python 3.9.13 as a global version
  #
  #   $ tau-global '3.9 3.11'
  #   [ℹ] Setting Python 3.9.13 as a global version
  #   [ℹ] Setting Python 3.11.2 as a global version
  #
  #   $ tau-global 1
  #   [✘] The input '1' does not match a valid version number.
  #
  #   $ tau-global '3.9 4.2'
  #   [ℹ] Setting Python 3.9.13 as a global version
  #   [✘] Could not find a match for '4.2'. Are you sure this Python version exists?
  #
  log_error "This function has been disabled. Please use 'tau-prefer' instead."
  return 1

  local minor_versions_input patch_versions_parsed version_minor version_patch
  IFS=" " read -rA minor_versions_input <<<"${*}"

  patch_versions_parsed=()
  for version_minor in "${minor_versions_input[@]}"; do
    version_patch="$(tau-latest-available "${version_minor}")"
    patch_versions_parsed=("${patch_versions_parsed[@]}" "${version_patch}")
  done

  log_info "Setting the following Python version(s) as global: ${patch_versions_parsed[*]}"
  pyenv global "${patch_versions_parsed[@]}"

  # TODO: This is not needed here, right? (don't hurt for now)
  tau-rehash
}
