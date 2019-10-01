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


# -- Install some Apps

# Text editors/IDEs
brew cask install qlmarkdown
brew cask install sublime-text
brew cask install brackets
brew cask install atom
brew cask install visual-studio-code
brew cask install texpad
mas install 497799835 # Xcode
mas install 1225570693 # Ulysses
# JetBrains
brew cask install pycharm
brew cask install datagrip
brew cask install webstorm

# Docker
brew cask install docker
brew cask install kitematic

# Misc Devs
brew cask install virtualbox
brew install awscli
brew cask install postman
#brew cask install paw

# Browsers
brew cask install google-chrome
brew cask install tor-browser
brew cask install firefox

# Productivity & Office
brew cask install alfred
brew cask install skitch
# brew cask install microsoft-office
mas install 462054704  # Microsoft Word
mas install 462058435  # Microsoft Excel
brew cask install skype
# brew cask install the-unarchiver
mas install 425424353  # The Unarchiver
# brew cask install whatsapp
mas install 1147396723  # WhatsApp
# brew cask install slack
mas install 803453959  # Slack
mas install 1176895641  # Spark

# Misc
brew cask install vuze
brew cask install spotify
brew cask install vlc
brew cask install adobe-creative-cloud
brew cask install blender
brew cask install appcleaner
brew cask install omnidisksweeper
brew cask install muzzle
brew cask install p4v
brew cask install diffmerge
mas install 909566003 # iHex
mas install 909760813 # Who's On My WiFi


# Manual install:
# - Popcorn-Time
# - Streamio
# - Photoshop
# - Lightroom
# - Affinity Photo
# - Affinity Designer
# - File Viewer
# -


# Upgrade everything again, and cleanup!
brew update && brew upgrade && brew cleanup


# Set up Sublime  ---
git clone https://github.com/andresmichel/one-dark-theme.git
mv one-dark-theme ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/Theme\ -\ One\ Dark
cp settings/Preferences.sublime-settings ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/Preferences.sublime-settings
