#!/usr/bin/env bash


# ============================================================================
# --- Ask for root password upfront and keep updating the existing `sudo`
# --- timestamp on a background process until the script finishes. Note that
# --- you'll still need to use `sudo` where needed throughout the scripts.
# ============================================================================
sudo -v
while true; do
  sudo -n true
  sleep 30
  kill -0 "$$" || exit
done 2>/dev/null &


# ===================================================================
# --- Install bash
# ===================================================================
brew install bash
brew install bash-completion2


# ===================================================================
# --- Install and configure zsh
# ===================================================================

# Install zsh
brew install zsh

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Powerlevel10k
brew install romkatv/powerlevel10k/powerlevel10k
p10k configure
git clone https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
brew install zsh-autosuggestions
brew install zsh-syntax-highlighting

# Change the default shell to the brew-install zsh
BREW_PREFIX="$(brew --prefix)"
if ! fgrep -q "${BREW_PREFIX}/bin/zsh" /etc/shells; then
  echo "${BREW_PREFIX}/bin/zsh" | sudo tee -a /etc/shells;
  chsh -s "${BREW_PREFIX}/bin/zsh";
fi;
