# Helper functions to backup and update dotfiles using Mackup
# For context, see:
# * <https://github.com/lra/mackup/issues/1924>

dot-backup() {
  if [[ "$*" == *--help* ]]; then
    echo "Usage: dot-backup [OPTIONS]"
    echo ""
    echo "Copy files from the local machine to Mackup's backup directory"
    echo ""
    echo "Options:"
    echo "    --help      Show this help message and exit"
    return 0
  fi
  log_info "Backing up Mackup-managed files..."
  mackup backup --force
}

dot-update-system() {
  if [[ "$*" == *--help* ]]; then
    echo "Usage: dot-update-system [OPTIONS]"
    echo ""
    echo "Copy files from Mackup's backup directory to the local machine"
    echo ""
    echo "Options:"
    echo "    --restart-shell     Restart the shell after restoring dotfiles"
    echo "    --help              Show this help message and exit"
    return 0
  fi
  log_info "Restoring Mackup-managed files..."
  mackup restore --force
  if [[ "$*" == *--restart-shell* ]]; then
    log_warning "Restarting the shell to apply dotfiles changes..."
    exec zsh
  fi
}
