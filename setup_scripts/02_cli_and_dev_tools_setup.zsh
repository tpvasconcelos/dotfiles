#!/usr/bin/env zsh

# ============================================================================
# --- Ask for root password upfront and keep updating the existing `sudo`
# --- timestamp on a background process until the script finishes. Note that
# --- you'll still need to use `sudo` where needed throughout the scipts.
# ============================================================================
sudo -v
while true; do
  sudo -n true
  sleep 30
  kill -0 "$$" || exit
done 2>/dev/null &


# Install GNU utils  ---
brew install coreutils  # PATH="$BREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"
brew install findutils  # PATH="$BREW_PREFIX/opt/findutils/libexec/gnubin:$PATH"
brew install gnu-sed    # PATH="$BREW_PREFIX/opt/gnu-sed/libexec/gnubin:$PATH"
brew install gnu-tar    # PATH="$BREW_PREFIX/opt/gnu-tar/libexec/gnubin:$PATH"
brew install grep       # PATH="$BREW_PREFIX/opt/grep/libexec/gnubin:$PATH"
brew install moreutils

# Install more recent versions of some macOS tools.
brew install vim
brew install openssh
brew install screen
brew install gmp

# Install font tools.
# Error: Cask 'font-hack-nerd-font' is unavailable: No Cask with this name exists.
brew tap bramstein/webfonttools
brew install sfnt2woff
brew install sfnt2woff-zopfli
brew install woff2
brew tap homebrew/cask-fonts
brew cask install font-juliamono
brew cask install font-hack-nerd-font

# Useful command line tools
brew install wget
brew install tree
brew install rename
brew install htop
brew install git && git lfs install
brew install git-lfs
brew install hub
brew install mdv
brew install howdoi
pip install termdown

# Misc tools
brew install luarocks
brew install openssl
brew install readline
brew install sqlite3
brew install xz
brew install zlib
brew install sqlite
brew install postgresql
brew install freetype
brew install libxslt
brew install libpq
brew install node
brew install yarn
brew install redis
brew cask install adoptopenjdk
brew install gnupg2
brew install mackup
brew install mas
brew install ffmpeg
brew install tree
brew install thefuck
brew install ncdu               # https://dev.yorhel.nl/ncdu
brew install shellcheck         # https://github.com/koalaman/shellcheck

# More compilers
brew install cmake
brew install llvm
brew install gcc
brew install libomp

# Docker
brew cask install docker
brew cask install kitematic

# Misc Devs
brew cask install virtualbox
brew install awscli
brew install pre-commit
brew install shellcheck  # (for pre-commit hooks with shellcheck)
brew install cookiecutter

# Golang
brew install golang  # old unnavailable flag: --cross-compile-common
mkdir -p "$HOME"/go/bin "$HOME"/go/src

# Kubernetes
brew install kubectx  # https://github.com/ahmetb/kubectx
brew install derailed/k9s/k9s  # https://github.com/derailed/k9s
brew install kube-ps1  # https://github.com/jonmosco/kube-ps1
brew install aws-iam-authenticator  # https://github.com/kubernetes-sigs/aws-iam-authenticator
brew install helm  # https://github.com/helm/helm
helm plugin install https://github.com/databus23/helm-diff --version master  # https://github.com/databus23/helm-diff

# Jekyll - <https://jekyllrb.com/docs/installation/macos/>
brew install ruby
brew install rbenv
rbenv install 2.7.2
rbenv global 2.7.2
sudo gem install bundler
# the next commands do not work... Probably something to do with current cpp compiler?
sudo gem install -n "$BREW_PREFIX/bin/" jekyll
sudo gem install --user-install bundler jekyll


# Flutter
# https://flutter.dev/docs/get-started/install/macos
# the next commands do not work... Probably something to do with current cpp compiler?
sudo gem install cocoapods
gem install cocoapods --user-install
pod setup
brew tap dart-lang/dart
brew install dart
git clone https://github.com/flutter/flutter.git -b stable --depth 1 ~/.flutter


# Upgrade everything again, and cleanup!
brew update && brew upgrade && brew cleanup
