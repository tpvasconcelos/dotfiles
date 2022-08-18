hc-update-everything() {
  if [ "$1" = "--help" ]; then
    echo "Usage: hc-update-everything [option]"
    echo ""
    echo "Options:"
    echo "    --brew-greedy      Also update brew casks that only have a :latest version tag"
    echo "    --system           Also run a system software update"
    echo "    --help             Show this help message"
    return
  fi

  # Update brew packages
  brew update
  brew bundle --global --no-lock
  brew upgrade

  if [ "$1" = "--brew-greedy" ]; then
    # Also update brew casks that only have a `:latest` version tag
    brew upgrade --greedy-latest
  fi

  # Update rust
  rustup update

  if [ "$1" = "--system" ]; then
    # Also run a system software update
    sudo softwareupdate --install --all --verbose --force --agree-to-license
  fi
}

hc-clear-caches() {
  if [ "$1" = "--help" ]; then
    echo "Usage: hc-clear-caches [option]"
    echo ""
    echo "Options:"
    echo "    --cleanup-brew-bundle  Uninstall all dependencies not listed in the Brewfile"
    echo "    --help                 Show this help message"
    return
  fi

  if [ "$1" = "--cleanup-brew-bundle" ]; then
    # Uninstall all dependencies not listed in the Brewfile
    brew bundle cleanup --global --force
  fi

  # clear homebrew's caches
  brew cleanup -s

  # Clears caches (pipenv, pip, and pip-tools)
  pipenv --clear

  # Remove docker's unused data
  docker system prune --volumes
}
