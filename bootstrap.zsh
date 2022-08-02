#!/usr/bin/env zsh
set -eu


################################################################################
# Import helper logging functions
################################################################################
echo "Importing helper logging functions..."

DOTFILES_DIR="$(dirname "$(readlink "$HOME/.zshenv")")"
SHELL_DIR_FUNCTIONS="${DOTFILES_DIR}/shell/functions"

source "${SHELL_DIR_FUNCTIONS}/ansi.zsh"
source "${SHELL_DIR_FUNCTIONS}/logging.zsh"
source "${SHELL_DIR_FUNCTIONS}/reboot.zsh"
source "${SHELL_DIR_FUNCTIONS}/string.zsh"
source "${SHELL_DIR_FUNCTIONS}/tau.zsh"


################################################################################
# Functions
################################################################################
log_debug "Defining script functions..."

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
log_warning "Some of the commands in this script require root access. Enter your password to unable root access when necessary..."
sudo -v
while true; do
  sudo -n true
  sleep 30
  kill -0 "$$" || exit
done 2>/dev/null &


################################################################################
# Homebrew and Brewfile dependencies
################################################################################
if ! type brew &>/dev/null; then
  log_info "🚀 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

log_info "🚀 Installing Brewfile dependencies..."
brew bundle --no-lock --file=Mackup/.Brewfile

BREW_PREFIX="$(brew --prefix)"
alias ln="${BREW_PREFIX}/opt/coreutils/libexec/gnubin/ln"


################################################################################
# Install stuff not specified in Brewfile
################################################################################
log_info "🚀 Installing stuff not specified in Brewfile..."


########################
# Shell tools
########################

PATH_TO_SHELL="${BREW_PREFIX}/bin/zsh"
if ! grep -F -q "${PATH_TO_SHELL}" /etc/shells; then
  log_info "Changing the default shell to the brew-installed zsh shell..."
  echo "${PATH_TO_SHELL}" | sudo tee -a /etc/shells
  chsh -s "${PATH_TO_SHELL}"
else
  log_debug "The default shell is already set to the brew-installed zsh shell."
fi

if [[ -v ZSH ]]; then
  log_debug "oh-my-zsh is already installed..."
else
  log_info "Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

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
# TODO: use tau-install-all && tau_cleanup
tau-install 3.7
tau-install 3.8
tau-install 3.9
tau-install 3.10 && tau-global 3.10
eval "$(pyenv init --path)"

POETRY_OMZ_PLUGIN_PATH="$ZSH_CUSTOM/plugins/poetry"
if [[ -d "$POETRY_OMZ_PLUGIN_PATH" ]]; then
  log_debug "poetry already installed!"
else
  log_info "Installing poetry..."
  pipx install poetry
  mkdir -p "$POETRY_OMZ_PLUGIN_PATH"
  poetry completions zsh >"$ZSH_CUSTOM/plugins/poetry/_poetry"
fi

# Install pipenv
pipx install pipenv

# Create playground venv
PY_PLAYGROUND_VENV="${HOME}/.venv"
if [[ ! -d "$PY_PLAYGROUND_VENV" ]]; then
  mkdir "$PY_PLAYGROUND_VENV"
fi
python -m venv "$PY_PLAYGROUND_VENV"


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
gsc https://github.com/andresmichel/one-dark-theme.git "$HOME/Library/Application Support/Sublime Text/Packages/Theme - One Dark"

log_info "Install github-markdown-toc..."
curl https://raw.githubusercontent.com/ekalinin/github-markdown-toc/master/gh-md-toc -o gh-md-toc
sudo mv gh-md-toc /usr/local/bin
chmod a+x /usr/local/bin/gh-md-toc


################################################################################
# Extra config steps
################################################################################
log_info "🚀 Performing final config steps..."

log_info "Symlinking the openjdk JDK (exposing it to the system Java wrappers)"
sudo ln -sfn "${BREW_PREFIX}/opt/openjdk@11/libexec/openjdk.jdk" /Library/Java/JavaVirtualMachines/openjdk-11.jdk

log_info "Creating bin/ and src/ directories for Golang..."
mkdir -p "$HOME"/go/bin "$HOME"/go/src

log_info "🚀 Setting up macOS preferences..."
# This will update many of the default macos settings and system preferences.
./macos.zsh

log_info "Restoring other preferences (using Mackup)..."
ln -sTfv "$(realpath .mackup.cfg)" "$HOME/.mackup.cfg"
mackup restore --force

log_info "Linking shell startup scripts..."
ln -sTfv "$(realpath .zshenv)" "$HOME/.zshenv"
ln -sTfv "$(realpath .zprofile)" "$HOME/.zprofile"
ln -sTfv "$(realpath .zshrc)" "$HOME/.zshrc"

log_info "🚀 Cloning git repos..."
./clones.zsh


###############################################################################
# Reboot
###############################################################################
log_warning "❗❗ It is recommended to reboot your machine after running this script. ❗❗"
reboot
