# Utilities for managing multiple python versions on a single machine

_tau::source_tau_modules(){
  # shellcheck source=functions/_tau.zsh
  for tau_module in "$SHELL_DIR_FUNCTIONS/_tau"/*(.); do
    source "$tau_module"
  done
}

_tau::source_tau_modules
