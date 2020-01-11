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

# Install more recent versions of some macOS tools.
brew install vim
brew install grep
brew install openssh
brew install screen
brew install php
brew install gmp

# Install font tools.
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
brew install git && git lfs install
brew install git-lfs
brew install hub
brew install mdv
brew install howdoi
pip install termdown

# Misc tools
brew install luarocks
brew install zlib
brew install sqlite
brew install postgresql && sudo pip install psycopg2
brew install freetype
brew install libxslt
brew install libpq
brew install node@10
brew install yarn && yarn && yarn build
brew install redis
npm install -g lookml-parser
pip install lookml-tools
brew cask install adoptopenjdk
brew install gnupg2
brew install mackup
brew install mas

# Xcode
mas install 497799835
sudo rm -rf /Library/Developer/CommandLineTools
xcode-select --install
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
sudo sudo xcodebuild -license accept

# Compilers
brew install cmake
brew install llvm
brew install gcc

# Docker
brew cask install docker
brew cask install kitematic

# Misc Devs
brew cask install virtualbox
brew install awscli

# Jekyll
gem install --user-install bundler jekyll

# Upgrade everything again, and cleanup!
brew update && brew upgrade && brew cleanup
