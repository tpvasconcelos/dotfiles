dot-backup() {
  # Copy files from the local machine to Mackup's backup directory
  log_info "Backing up Mackup-managed files..."
  mackup backup --force
  # https://github.com/lra/mackup/issues/1924
  mackup uninstall --force
}

dot-update-system() {
  # Copy files from Mackup's backup directory to the local machine
  log_info "Restoring Mackup-managed files..."
  mackup restore --force
  # https://github.com/lra/mackup/issues/1924
  mackup uninstall --force
}
