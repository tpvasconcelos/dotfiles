#!/usr/bin/env bash


# Ask for the root user and password upfront and keep updating the existing
# `sudo` timestamp on a background process until the script finishes
# Note that you'll still to use `sudo` where needed throughout the scipt
sudo -v
while true; do
  sudo -n true
  sleep 30
  kill -0 "$$" || exit
done 2>/dev/null &


# Install Homebrew (brew)  ---
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
# Upgrade everything
brew update && brew upgrade
# Save Homebrew’s installed location --> /usr/local
BREW_PREFIX=$(brew --prefix)


# Install a modern version of Bash  ---
brew install bash
brew install bash-completion2
# Switch to using brew-installed bash as default shell
if ! fgrep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
  echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells;
  chsh -s "${BREW_PREFIX}/bin/bash";
fi;


# Install zsh (and oh-my-zsh)  ---
brew install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# Powerlevel10k
brew install romkatv/powerlevel10k/powerlevel10k
p10k configure
git clone https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
brew install zsh-autosuggestions
brew install zsh-syntax-highlighting
# Change the default shell to zsh
chsh -s /bin/zsh


# Install iTerm2  ---
brew cask install iterm2
killall cfprefsd
cp shell/com.googlecode.iterm2.plist ~/Library/Preferences
# Download Shell Integration script
curl -L https://iterm2.com/shell_integration/zsh -o ~/.iterm2_shell_integration.zsh
