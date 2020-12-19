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
brew install --cask qlmarkdown
brew install --cask brackets
brew install --cask atom
brew install --cask visual-studio-code
brew install --cask texpad
mas install 497799835 && sudo xcodebuild -license accept # Xcode
brew install --cask pycharm
brew install --cask datagrip
brew install --cask webstorm
echo "🚀 Setting-up Sublime Text"
brew install --cask sublime-text
sublime_pkgs="$(echo ~/Library/Application\ Support/Sublime\ Text*/Packages)"
git clone --depth=1 https://github.com/andresmichel/one-dark-theme.git "${sublime_pkgs}/Theme - One Dark"
ln -shfv "$(realpath settings/Preferences.sublime-settings)" "${sublime_pkgs}/User/Preferences.sublime-settings"

echo "🚀 Installing Browsers..."
brew install --cask google-chrome
brew install --cask tor-browser
brew install --cask firefox
brew install --cask brave-browser
# Safari Extensions
mas install 1462114288  # Grammarly


echo "🚀 Installing Productivity & Office apps..."
mas install 462054704 # Microsoft Word: brew install --cask microsoft-office
mas install 462058435 # Microsoft Excel
mas install 425424353  # The Unarchiver: brew install --cask the-unarchiver
mas install 1147396723 # WhatsApp: brew install --cask whatsapp
mas install 803453959  # Slack: brew install --cask slack
mas install 1176895641 # Spark
brew install --cask alfred
brew install --cask skitch
brew install --cask skype
brew install --cask the-unarchiver
brew install --cask whatsapp
brew install --cask slack
brew install --cask google-drive
brew install --cask notion
brew install --cask keepingyouawake


echo "🚀 Installing Misc apps..."
brew install --cask vuze
brew install --cask spotify
brew install --cask vlc
brew install --cask adobe-creative-cloud
brew install --cask blender
brew install --cask appcleaner
brew install --cask disk-inventory-x      # <http://www.derlien.com/>
brew install --cask muzzle
brew install --cask p4v
brew install --cask diffmerge
brew install --cask postman
brew install --cask jupyter-notebook-viewer
#brew install --cask paw
# brew install --cask popcorn-official/popcorn-desktop/popcorn-time
mas install 909566003 # iHex
mas install 909760813 # Who's On My WiFi
mas install 668208984 # GIPHY Capture. The GIF Maker


echo "🚀 update, upgrade, and cleanup..."
brew update && brew upgrade && brew cleanup
