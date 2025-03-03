# Utilities for managing multiple python versions on a single machine

# shellcheck source=functions/_tau/tau-upgrade.zsh
for tau_module in "$SHELL_DIR_FUNCTIONS/_tau"/*(.); do
  source "$tau_module"
done
