#!/usr/bin/env zsh
set -eu

# ============================================================================
# --- Ask for root password upfront and keep updating the existing `sudo`
# --- timestamp on a background process until the script finishes. Note that
# --- you'll still need to use `sudo` where needed throughout the scripts.
# ============================================================================
log_info "Some of the commands in this script require root access. Enter your password to unable root access when necessary..."
sudo -v
while true; do
  sudo -n true
  sleep 30
  kill -0 "$$" || exit
done 2>/dev/null &


echo "🚀 Installing Text editors and IDEs..."
brew cask install qlmarkdown
brew cask install brackets
brew cask install atom
brew cask install visual-studio-code
brew cask install texpad
mas install 497799835 && sudo xcodebuild -license accept # Xcode
brew cask install pycharm
brew cask install datagrip
brew cask install webstorm
echo "🚀 Setting-up Sublime Text"
brew cask install sublime-text
sublime_pkgs="$(echo ~/Library/Application\ Support/Sublime\ Text*/Packages)"
git clone --depth=1 https://github.com/andresmichel/one-dark-theme.git "${sublime_pkgs}/Theme - One Dark"
ln -shfv "$(realpath settings/Preferences.sublime-settings)" "${sublime_pkgs}/User/Preferences.sublime-settings"

echo "🚀 Installing Browsers..."
brew cask install google-chrome
brew cask install tor-browser
brew cask install firefox


echo "🚀 Installing Productivity & Office apps..."
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


echo "🚀 Installing Misc apps..."
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
brew cask install postman
brew cask install jupyter-notebook-viewer
#brew cask install paw
# brew cask install popcorn-official/popcorn-desktop/popcorn-time
mas install 909566003 # iHex
mas install 909760813 # Who's On My WiFi
mas install 668208984 # GIPHY Capture. The GIF Maker


echo "🚀 update, upgrade, and cleanup..."
brew update && brew upgrade && brew cleanup
