#!/usr/bin/env bash

echo "🚀 Installing bash..."
brew install bash
brew install bash-completion2

echo "🚀 Installing zsh..."
brew install zsh

echo "🚀 Installing oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "🚀 Installing Powerlevel10k..."
brew install romkatv/powerlevel10k/powerlevel10k
p10k configure
git clone https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
brew install zsh-autosuggestions
brew install zsh-syntax-highlighting

PATH_TO_SHELL="$(brew --prefix)/bin/zsh"
echo "🚀 Changing the default shell to the brew-installed zsh shell ---> ${PATH_TO_SHELL}"
if ! fgrep -q "${PATH_TO_SHELL}" /etc/shells; then
  echo "${PATH_TO_SHELL}" | sudo tee -a /etc/shells
  chsh -s "${PATH_TO_SHELL}"
fi
