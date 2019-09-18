#!/usr/bin/env bash

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Upgrade everything
brew update && brew upgrade


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
brew install git
brew install git-lfs
brew install hub
brew install mdv
brew install howdoi

# Misc tools
brew install zlib
brew install sqlite
brew install postgresql && sudo pip install psycopg2
# brew tap mongodb/brew && brew install mongodb-community@4.2
brew install freetype
brew install libxslt
brew install libpq
brew install node@10
brew install yarn && yarn && yarn build
brew install redis
npm install -g lookml-parser
pip install lookml-tools


# Upgrade everything again, and cleanup!
brew update && brew upgrade && brew cleanup