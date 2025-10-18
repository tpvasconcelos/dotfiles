dot-backup() {
  # Copy files from the local machine to Mackup's backup directory
  # https://github.com/lra/mackup/issues/1924
  log_info "Backing up Mackup-managed files..."
  mackup backup --force && mackup install --force
}

dot-update-system() {
  # Copy files from Mackup's backup directory to the local machine
  # https://github.com/lra/mackup/issues/1924
  log_info "Restoring Mackup-managed files..."
  mackup restore --force && mackup uninstall --force
}
