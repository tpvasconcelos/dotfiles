backdot() {
  log_info "Backing up Mackup-managed files..."
  mackup backup --force
  # https://github.com/lra/mackup/issues/1924
  mackup uninstall --force
}
