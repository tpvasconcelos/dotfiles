#!/usr/bin/env bash
set -eu

log_info "Installing bash..." | underline
brew install bash
brew install bash-completion2

log_info "Installing zsh..."
brew install zsh

log_info "Installing oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

log_info "Installing Powerlevel10k..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

log_info "Installing zsh-autosuggestions..."
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions

log_info "Installing zsh-syntax-highlighting..."
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting

PATH_TO_SHELL="$(brew --prefix)/bin/zsh"
log_info "Changing the default shell to the brew-installed zsh shell ---> ${PATH_TO_SHELL}"
if ! fgrep -q "${PATH_TO_SHELL}" /etc/shells; then
  echo "${PATH_TO_SHELL}" | sudo tee -a /etc/shells
  chsh -s "${PATH_TO_SHELL}"
fi
