__check_expired_gpg_keys() {
  # Check for expired gpg keys
  yellow-bold() {
    fg_yellow "$(bold "$*")"
  }
  if gpg --list-keys | grep -q expired; then
    log_warning "Found expired GPG keys!"
    echo "Steps to update them:"
    echo "1. Run $(yellow-bold 'gpg --list-keys --with-subkey-fingerprints') to check the fingerprints of the expired keys."
    echo "2. Run $(yellow-bold 'gpg --quick-set-expire FINGERPRINT EXPIRE [SUBKEY-FPRS]') to update them."
    echo "For instance, to update the 'ABC123' key and its DEF456 subkey to expire in 1 year, run:"
    yellow-bold "$ gpg --quick-set-expire 'ABCD1234' '1y' 'DEF456'"
  else
    log_success "No expired GPG keys found!"
  fi
}

__check_dotfiles() {
  # Check DOTFILES_DIR is set
  if [[ -z "$DOTFILES_DIR" ]]; then
    log_error "The DOTFILES_DIR environment variable is not set!"
    echo "The default location should be ~/.dotfiles."
    echo "Please refer to https://github.com/tpvasconcelos/dotfiles for more information."
    return 1
  fi

  # https://github.com/AGWA/git-crypt/issues/69#issuecomment-1129962604
  if git -C "$DOTFILES_DIR" config --local --get filter.git-crypt.smudge | grep -q 'smudge'; then
    log_success "The dotfiles repository is unlocked!"
  else
    log_error "The dotfiles repository is locked with git-crypt!"
    echo "Please unlock it by running $(bold 'git-crypt unlock') or refer to"
    echo "https://github.com/tpvasconcelos/dotfiles#unlocking-this-repository for more information."
  fi
}

hc-doctor() {
  if [[ "$*" == *--help* ]]; then
    echo "Usage: hc-doctor [OPTIONS]"
    echo ""
    echo "Options:"
    echo "    --skip-dot-backup     Skip backing up dotfiles"
    echo "    --skip-system         Skip checking for system software updates"
    echo "    --skip-brewfile       Skip Brewfile checks"
    echo "    --skip-brew-doctor    Skip running brew doctor"
    echo "    --help                Show this help message and exit"
    return 0
  fi

  if [[ "$*" != *--skip-dot-backup* ]]; then
    dot-backup
  fi

  if [[ "$*" != *--skip-system* ]]; then
    log_info "Checking for system software updates..."
    softwareupdate_output=$(softwareupdate --list --all)
    if [[ "$softwareupdate_output" == *"found the following new or updated software"* ]]; then
      log_warning "Found available software updates:"
      softwareupdate_filtered="$(echo "$softwareupdate_output" | awk 'NR > 4')"
      fg_yellow "$softwareupdate_filtered"
    else
      log_success "System software is up-to-date!"
    fi
  fi

  __check_dotfiles
  __check_expired_gpg_keys

  if [[ "$*" != *--skip-brewfile* ]]; then
    brew_bundle_cleanup_output=$(brew bundle cleanup --global 2>&1)
    if [[ $? -ne 0 ]]; then
      log_error "Error running brew bundle cleanup:"
      echo "$brew_bundle_cleanup_output"
    elif [[ -n "$brew_bundle_cleanup_output" ]]; then
      log_warning "Found installed packages not listed in the global Brewfile! You may want to update it."
      echo "${brew_bundle_cleanup_output//brew bundle cleanup/brew bundle cleanup --global}"
    else
      log_success "All installed packages are listed in the global Brewfile!"
    fi
  fi

  brew_outdated_output=$(brew outdated --verbose)
  if [[ -n "$brew_outdated_output" ]]; then
    log_warning "Found outdated brew packages:"
    fg_yellow "$brew_outdated_output"
  else
    log_success "Brew packages are up-to-date!"
  fi

  if [[ "$*" != *--skip-brew-doctor* ]]; then
    log_info "Running brew doctor..."
    brew doctor
  fi
}

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

  # Update oh-my-zsh
  if [[ -n "$ZSH" ]]; then
    zsh "$ZSH/tools/upgrade.sh" -v minimal
  else
    log_warning "Skipping omz update. ZSH is not available which means that you're probably running in non-interactive mode."
  fi

  if [[ "$*" == *--system* ]]; then
    # System software update
    sudo softwareupdate --install --all --verbose --force --agree-to-license
  fi

  # Update brew packages
  brew update
  brew bundle --global
  brew upgrade
  if [[ "$*" == *--brew-greedy-latest* ]]; then
    # Also update brew casks with a :latest version tag
    brew upgrade --greedy-latest
  fi

  # Update all uv tools
  uv tool upgrade --all

  # Update rust
  rustup update

  # Update Flutter and Dart
  if [[ "$*" == *--flutter* ]]; then
    flutter-update
  fi

  # Upgrade all `gh` CLI extensions
  gh extension upgrade --all

  # Update npm
  npm install npm --global --no-fund
  npm update --global --no-fund

  # Update yarn
  yarn global upgrade

  # Update Ruby gems
  sudo gem update --system

  # Check for expired gpg keys
  __check_expired_gpg_keys

  # Backup dotfiles
  dot-backup

  log_success "Done! 🚀"

  # Restart the shell
  exec zsh
}

hc-reclaim-diskspace() {
  if [[ "$*" == *--help* ]]; then
    echo "Usage: hc-update-everything [OPTIONS]"
    echo ""
    echo "Options:"
    echo "    --skip-uv         Skip clearing uv caches"
    echo "    --skip-nix-store  Skip clearing Nix store"
    echo "    --help            Show this help message and exit"
    return 0
  fi

  log_info "Clearing homebrew's caches..."
  brew cleanup -s

  log_info "Clearing pipenv, pip, and pip-tools caches..."
  pipenv --clear

  log_info "Clearing npm caches..."
  npm cache clean --force

  log_info "Clearing yarn caches..."
  yarn cache clean

  log_info "Clearing pnpm caches..."
  pnpm store prune

  log_info "Clearing Ruby gems caches..."
  sudo gem cleanup

  if [[ "$*" == *--skip-uv* ]]; then
    log_info "Skipping uv caches clearing..."
  else
    log_info "Clearing uv caches..."
    uv cache prune
  fi

  if [[ "$*" == *--skip-nix-store* ]]; then
    log_info "Skipping Nix store clearing..."
  else
    log_info "Clearing Nix store..."
    nix-store --gc
  fi

  if docker stats --no-stream &> /dev/null; then
    log_info "Removing docker's unused data..."
    docker system prune --volumes
  else
    log_warning "Docker is not running. Skipping docker's unused data removal."
  fi

  log_info "Clearing Simulator data..."
  xcrun simctl delete unavailable
  if [[ -n $(/bin/ls -A ~/Library/Developer/CoreSimulator/Caches) ]]; then
    log_warning "Directory ~/Library/Developer/CoreSimulator/Caches is not empty! ($(du -sh ~/Library/Developer/CoreSimulator/Caches | awk '{print $1}'))"
    echo "You can remove them manually if you want, or run the following command to permanently delete all files and subdirectories:"
    echo "rm -rf ~/Library/Developer/CoreSimulator/Caches/*"
  fi
}
