#!/usr/bin/env zsh

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

# -- Install some Apps

# Text editors/IDEs
brew cask install qlmarkdown
brew cask install sublime-text
brew cask install brackets
brew cask install atom
brew cask install visual-studio-code
brew cask install texpad
mas install 497799835 && sudo xcodebuild -license accept # Xcode
brew cask install pycharm
brew cask install datagrip
brew cask install webstorm

# Misc dev
brew cask install postman
#brew cask install paw

# Browsers
brew cask install google-chrome
brew cask install tor-browser
brew cask install firefox

# Productivity & Office
mas install 462054704 # Microsoft Word: brew cask install microsoft-office
mas install 462058435 # Microsoft Excel
mas install 425424353  # The Unarchiver: brew cask install the-unarchiver
mas install 1147396723 # WhatsApp: brew cask install whatsapp
mas install 803453959  # Slack: brew cask install slack
mas install 1176895641 # Spark
brew cask install alfred
brew cask install skitch
brew cask install skype
brew cask install the-unarchiver
brew cask install whatsapp
brew cask install slack
brew cask install google-drive
brew cask install notion
brew cask install keepingyouawake

# Misc
brew cask install vuze
brew cask install spotify
brew cask install vlc
brew cask install adobe-creative-cloud
brew cask install blender
brew cask install appcleaner
brew cask install disk-inventory-x      # <http://www.derlien.com/>
brew cask install muzzle
brew cask install p4v
brew cask install diffmerge
# brew cask install popcorn-official/popcorn-desktop/popcorn-time
mas install 909566003 # iHex
mas install 909760813 # Who's On My WiFi
mas install 668208984 # GIPHY Capture. The GIF Maker

# Manual install:
# - Photoshop
# - Lightroom
# - Affinity Photo
# - Affinity Designer
# - File Viewer

# Upgrade everything again, and cleanup!
brew update && brew upgrade && brew cleanup

# Set up Sublime  ---
git clone https://github.com/andresmichel/one-dark-theme.git
mv one-dark-theme ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/Theme\ -\ One\ Dark
cp settings/Preferences.sublime-settings ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/Preferences.sublime-settings
