#!/usr/bin/env bash

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

# Upgrade everything
brew update && brew upgrade
brew cask upgrade --greedy

# create ~/dev/ directory
mkdir ~/dev/

# Install more recent versions of some macOS tools.
brew install vim
brew install grep
brew install openssh
brew install screen
brew install php
brew install gmp

# Install font tools.
# Error: caskroom/fonts was moved. Tap homebrew/cask-fonts instead.
# Error: Cask 'font-hack-nerd-font' is unavailable: No Cask with this name exists.
brew tap bramstein/webfonttools
brew install sfnt2woff
brew install sfnt2woff-zopfli
brew install woff2
brew tap caskroom/fonts
brew cask install font-hack-nerd-font

# Useful command line tools
brew install wget
brew install tree
brew install rename
brew install htop
#Bash completion has been installed to:
#  /usr/local/etc/bash_completion.d
#
#zsh completions and functions have been installed to:
#  /usr/local/share/zsh/site-functions
#
#Emacs Lisp files have been installed to:
#  /usr/local/share/emacs/site-lisp/git
brew install git
#ERROR: git: 'lfs' is not a git command. See 'git --help'.
git lfs install
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
#The directory '/Users/tpvasconcelos/Library/Caches/pip/http' or its parent directory is not owned by the current user and the cache has been disabled. Please check the permissions and owner of that directory. If executing pip with sudo, you may want sudo's -H flag.
#The directory '/Users/tpvasconcelos/Library/Caches/pip' or its parent directory is not owned by the current user and caching wheels has been disabled. check the permissions and owner of that directory. If executing pip with sudo, you may want sudo's -H flag.
#Running setup.py install for psycopg2 ... error
sudo pip install psycopg2
brew install freetype
brew install libxslt
brew install libpq
brew install node
brew install yarn && yarn && yarn build
brew install redis
brew cask install adoptopenjdk
brew install gnupg2
brew install mackup
brew install mas
brew install ffmpeg
brew cask install keepingyouawake
brew install tree
brew install thefuck

# Xcode
mas install 497799835
sudo rm -rf /Library/Developer/CommandLineTools
xcode-select --install
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
sudo sudo xcodebuild -license accept
sudo xcodebuild -runFirstLaunch
softwareupdate --force --install --all --verbose

# More compilers
brew install cmake
brew install llvm
brew install gcc
brew install libomp

# Docker
#Error: Download failed on Cask 'docker' with message: Download failed: https://download.docker.com/mac/stable/40693/Docker.dmg
brew cask install docker
brew cask install kitematic

# Misc Devs
brew cask install virtualbox
brew install awscli
brew install pre-commit
brew install shellcheck  # (for pre-commit hooks with shellcheck)

# Golang
brew install golang  --cross-compile-common
mkdir -p $HOME/go/bin $HOME/go/src

# Kubernetes
brew install kubectx  # https://github.com/ahmetb/kubectx
brew install derailed/k9s/k9s  # https://github.com/derailed/k9s
brew install kube-ps1  # https://github.com/jonmosco/kube-ps1
brew install aws-iam-authenticator  # https://github.com/kubernetes-sigs/aws-iam-authenticator
brew install helm  # https://github.com/helm/helm
helm plugin install https://github.com/databus23/helm-diff --version master  # https://github.com/databus23/helm-diff

# Jekyll
brew install ruby
brew install rbenv
eval "$(rbenv init -)"
rbenv install 2.7.0
sudo gem install bundler
sudo gem install --user-install bundler jekyll


# Flutter
# https://flutter.dev/docs/get-started/install/macos
sudo gem install cocoapods
gem install cocoapods --user-install
pod setup
brew tap dart-lang/dart
brew install dart
git clone https://github.com/flutter/flutter.git -b stable --depth 1 ~/dev/flutter


# Upgrade everything again, and cleanup!
brew update && brew upgrade && brew cleanup
