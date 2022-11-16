#!/usr/bin/env zsh
set -eu


################################################################################
# Import helper logging functions
################################################################################
SHELL_DIR_FUNCTIONS="${0:a:h}/shell/functions"
echo "[⋯] Importing helper logging functions from: $SHELL_DIR_FUNCTIONS"


source "$SHELL_DIR_FUNCTIONS/ansi.zsh"
source "$SHELL_DIR_FUNCTIONS/logging.zsh"
source "$SHELL_DIR_FUNCTIONS/misc.zsh"
source "$SHELL_DIR_FUNCTIONS/reboot.zsh"
source "$SHELL_DIR_FUNCTIONS/string.zsh"
source "$SHELL_DIR_FUNCTIONS/tau.zsh"


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
    log_debug "Directory already exists: $dir"
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
if cmd_exists brew; then
  log_success "Homebrew is already installed!"
else
  log_info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

log_info "Installing Brewfile dependencies..."
brew bundle --no-lock --file=Mackup/.Brewfile

BREW_PREFIX="$(brew --prefix)"
alias ln="${BREW_PREFIX}/opt/coreutils/libexec/gnubin/ln"

################################################################################
# Install stuff not specified in Brewfile
################################################################################
log_info "Installing stuff not specified in Brewfile..."


########################
# Shell tools
########################

PATH_TO_SHELL="${BREW_PREFIX}/bin/zsh"
if grep -F -q "$PATH_TO_SHELL" /etc/shells; then
  log_success "The default shell is already set to the brew-installed zsh shell."
else
  log_info "Changing the default shell to the brew-installed zsh shell..."
  echo "$PATH_TO_SHELL" | sudo tee -a /etc/shells
  chsh -s "$PATH_TO_SHELL"
fi

if [[ -v ZSH ]]; then
  log_success "oh-my-zsh is already installed!"
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
  log_success "Shell Integration and iTerm2 utilities already installed!"
else
  log_info "Installing Shell Integration and iTerm2 utilities..."
  curl -L https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | bash
fi


########################
# Python
########################

log_info "Installing the following python versions from pyenv: $PYENV_TARGET_VERSIONS"
tau-install-all
# TODO: tau-cleanup or something similar to automatically
#       add all minor versions as global versions
tau-global 3.10
eval "$(pyenv init --path)"

POETRY_OMZ_PLUGIN_PATH="$ZSH_CUSTOM/plugins/poetry"
if [[ -d "$POETRY_OMZ_PLUGIN_PATH" ]]; then
  log_success "poetry is already installed!"
else
  log_info "Installing poetry..."
  pipx install poetry
  mkdir -p "$POETRY_OMZ_PLUGIN_PATH"
  poetry completions zsh >"$ZSH_CUSTOM/plugins/poetry/_poetry"
fi

# Install pipenv
if pipx list | grep -q pipenv; then
  log_success "pipenv is already installed!"
else
  log_info "Installing pipenv..."
  pipx install pipenv
fi

if pipx list | grep -q cookiecutter; then
  log_success "cookiecutter is already installed!"
else
  log_info "Installing cookiecutter..."
  pipx install cookiecutter
fi

# Create playground venv
PY_PLAYGROUND_VENV="${HOME}/.venv"
if [[ -d "$PY_PLAYGROUND_VENV" ]]; then
  log_success "Playground venv already exists: $PY_PLAYGROUND_VENV"
else
  log_info "Creating playground venv at: $PY_PLAYGROUND_VENV"
  mkdir "$PY_PLAYGROUND_VENV"
  python -m venv "$PY_PLAYGROUND_VENV"
fi


########################
# Misc
########################

log_info "Installing git's LFS..."
git lfs install

if [[ -d "$HOME/.cargo/bin" ]]; then
  log_success "Rust already installed!"
else
  log_info "Installing Rust..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path --verbose -y
fi

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

if [[ -r /usr/local/bin/gh-md-toc ]]; then
  log_success "github-markdown-toc is already installed!"
else
  log_info "Install github-markdown-toc..."
  curl https://raw.githubusercontent.com/ekalinin/github-markdown-toc/master/gh-md-toc -o gh-md-toc
  sudo mv gh-md-toc /usr/local/bin
  chmod a+x /usr/local/bin/gh-md-toc
fi


################################################################################
# Extra config steps
################################################################################
log_info "Performing final config steps..."

log_info "Symlinking the openjdk JDK (exposing it to the system Java wrappers)"
# FIXME: check ln vs gln and flag compatibility
sudo ln -sfnh "${BREW_PREFIX}/opt/openjdk@11/libexec/openjdk.jdk" "/Library/Java/JavaVirtualMachines/openjdk-11.jdk"

log_info "Symlinking the openssl@1.1 as default openssl"
ln -sfnh "${BREW_PREFIX}/opt/openssl@1.1" "${BREW_PREFIX}/opt/openssl"

log_info "Creating bin/ and src/ directories for Golang..."
mkdir -p "$HOME/go/bin" "$HOME/go/src"

log_info "Restoring application settings (using Mackup)..."
ln -sTfv "$(realpath .mackup.cfg)" "$HOME/.mackup.cfg"
mackup restore --force

log_info "Setting up macOS preferences..."
log_warning "This will update many of the default settings and system preferences!"
./scripts/macos.zsh


################################################################################
# If exists, run the extra local bootstrap script
################################################################################
if [[ -r ./scripts/extra.zsh ]]; then
  log_info "Running extra local bootstrap script..."
  source ./scripts/extra.zsh
fi


###############################################################################
# Reboot
###############################################################################
log_warning "❗❗ It is recommended to reboot your machine after running this script. ❗❗"
reboot
