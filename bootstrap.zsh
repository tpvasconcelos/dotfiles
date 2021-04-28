#!/usr/bin/env zsh
set -eu


source "${SHELL_DIR_ENVIRONMENT}/functions/oncall/ansi.zsh"
source "${SHELL_DIR_ENVIRONMENT}/functions/oncall/logging.zsh"
source "${SHELL_DIR_ENVIRONMENT}/functions/oncall/sourcing.zsh"
source "${SHELL_DIR_INTERACTIVE}/functions/string.zsh"
source "${SHELL_DIR_INTERACTIVE}/functions/reboot.zsh"
source "${SHELL_DIR_INTERACTIVE}/functions/tau.zsh"

gsc() {
  # git shallow clone
  # Arguments:
  #   * $1 : repository
  #   * $2 : directory
  #   * $3 : branch
  local repo dir branch
  repo="${1}"
  dir="${2}"
  branch="${3:-}"

  if [[ -d "$dir" ]]; then
    git -C "$dir" pull
  elif [[ -z "$branch" ]]; then
    git clone --depth=1 --single-branch "$repo" "$dir"
  else
    git clone --depth=1 --single-branch --branch="$branch" "$repo" "$dir"
  fi
}


################################################################################
# Ask for root password upfront and keep updating the existing `sudo`
# timestamp on a background process until the script finishes. Note that
# you'll still need to use `sudo` where needed throughout the scripts.
################################################################################
log_info "Some of the commands in this script require root access. Enter your password to unable root access when necessary..."
sudo -v
while true; do
  sudo -n true
  sleep 30
  kill -0 "$$" || exit
done 2>/dev/null &



################################################################################
# Brewfile dependencies
################################################################################
log_info "🚀 Installing Brewfile dependencies..."
brew bundle --global

BREW_PREFIX="/usr/local"



################################################################################
# Install stuff not specified in Brewfile
################################################################################
log_info "🚀 Installing stuff not specified in Brewfile..."


########################
# Shell tools
########################

if [[ -v ZSH ]]; then
  log_debug "oh-my-zsh is already installed..."
else
  log_info "Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

log_info "Installing Powerlevel10k..."
gsc https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

log_info "Installing zsh-autosuggestions..."
gsc https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"

log_info "Installing zsh-syntax-highlighting..."
gsc https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

if [[ -r "${HOME}/.iterm2_shell_integration.zsh" ]]; then
  log_debug "Shell Integration and iTerm2 utilities already installed..."
else
  log_info "Installing Shell Integration and iTerm2 utilities..."
  curl -L https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | bash
fi


########################
# Python
########################

log_info "Installing all python versions from pyenv..."
# FIXME: tau_install_all && tau_cleanup
tau_install_all

log_info "Installing poetry..."
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python
poetry completions zsh > "$BREW_PREFIX/share/zsh/site-functions/_poetry"


########################
# Kubernetes tooling
########################

log_info "Installing microk8s..."
microk8s install -y
chronic microk8s status --wait-ready

# FIXME: https://github.com/ubuntu/microk8s/issues/1763
#log_info "Installing Kubeflow..."
#microk8s enable kubeflow


########################
# Misc
########################

log_info "Installing git's LFS..."
git lfs install

log_info "Installing Jekyll..."
# https://jekyllrb.com/docs/installation/macos/
gem install --conservative --user-install bundler jekyll

log_info "Installing Flutter..."
# https://flutter.dev/docs/get-started/install/macos
sudo gem install --conservative cocoapods
gem install --conservative --user-install cocoapods
pod setup
gsc https://github.com/flutter/flutter.git "$HOME/.flutter" stable

log_info "Installing Sublime Text's 'One Dark' theme..."
sublime_pkgs="$(echo ~/Library/Application\ Support/Sublime\ Text*/Packages)"
gsc https://github.com/andresmichel/one-dark-theme.git "${sublime_pkgs}/Theme - One Dark"


################################################################################
# Extra config steps
################################################################################
log_info "🚀 Performing extra/final config steps..."

# TODO: is this step necessary?
log_info "Unlinking homebrew's python..."
brew unlink python

log_info "Creating bin/ and src/ directories for Golang..."
mkdir -p "$HOME"/go/bin "$HOME"/go/src

log_info "Changing the default shell to the brew-installed zsh shell..."
PATH_TO_SHELL="${BREW_PREFIX}/bin/zsh"
if ! grep -F -q "${PATH_TO_SHELL}" /etc/shells; then
  echo "${PATH_TO_SHELL}" | sudo tee -a /etc/shells
  chsh -s "${PATH_TO_SHELL}"
fi

log_info "Setting up macOS preferences..."
./macos.zsh

################################################################################
# Cleanup...
################################################################################
brew update
#brew upgrade --greedy
brew cleanup -s --prune=all
brew bundle cleanup --global --force
