hc-update-everything() {
  if [[ "$*" == *--help* ]]; then
    echo "Usage: hc-update-everything [OPTIONS]"
    echo ""
    echo "Options:"
    echo "    --system              Run a system software update first"
    echo "    --brew-greedy-latest  Also update brew casks with a :latest version tag"
    echo "    --flutter             Also update Flutter and Dart"
    echo "    --help                Show this help message and exit"
    return 0
  fi

  if [[ "$*" == *--system* ]]; then
    # System software update
    sudo softwareupdate --install --all --verbose --force --agree-to-license
  fi

  # Update brew packages
  brew update
  brew bundle --global --no-lock
  brew upgrade
  if [[ "$*" == *--brew-greedy-latest* ]]; then
    # Also update brew casks with a :latest version tag
    brew upgrade --greedy-latest
  fi

  # Update pipx packages
  pipx upgrade-all

  # Update rust
  rustup update

  # Update Flutter and Dart
  if [[ "$*" == *--flutter* ]]; then
    flutter-update
  fi

  # Upgrade all `gh` CLI extensions
  gh extension upgrade --all

  # Update npm
  npm install npm --global
  npm update --globalyarn global upgrade

  # Update yarn
  yarn global upgrade

  # Update Ruby gems
  sudo gem update --system

  # Check for expired gpg keys
  yellow-bold() {
    fg_yellow "$(bold "$*")"
  }
  if gpg --list-keys | grep -q expired; then
    log_warning "Found expired GPG keys!"
    echo "Steps to update them:"
    echo "1. Run $(yellow-bold 'gpg --list-keys') to check the fingerprints of the expired keys."
    echo "2. Run $(yellow-bold 'gpg --quick-set-expire FINGERPRINT EXPIRE [SUBKEY-FPRS]') to update them."
    echo "For instance, to update the 'ABCD1234' key and all its subkeys to expire in 1 year, run:"
    yellow-bold "$ gpg --quick-set-expire 'ABCD1234' '1y' '*'"
  else
    log_success "No expired GPG keys found!"
  fi

  log_success "Done! 🚀"
}

hc-clear-caches() {
  if [[ "$*" == *--help* ]]; then
    echo "Usage: hc-clear-caches [OPTIONS]"
    echo ""
    echo "Options:"
    echo "    --cleanup-brew-bundle  Uninstall all dependencies not listed in the Brewfile"
    echo "    --skip-docker          Don't remove docker's unused data. Useful when the docker daemon is not running."
    echo "    --help                 Show this help message and exit"
    return
  fi

  if [[ "$*" == *--cleanup-brew-bundle* ]]; then
    log_info "Uninstalling all dependencies not listed in the Brewfile..."
    brew bundle cleanup --global --force
  fi

  log_info "Clearing homebrew's caches..."
  brew cleanup -s

  log_info "Clearing pipenv, pip, and pip-tools caches..."
  pipenv --clear

  if [[ "$*" != *--skip-docker* ]]; then
    log_info "Removing docker's unused data..."
    docker system prune --volumes
  else
    log_debug "Skipping docker's unused data removal, because --skip-docker was passed."
  fi
}
