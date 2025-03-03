#!/usr/bin/env zsh
set -eu


################################################################################
# Import some helper functions
################################################################################
DOTFILES_DIR="${0:a:h}"
SHELL_FUNCTIONS_DIR="$DOTFILES_DIR/shell/functions"

echo "[⋯] Importing helper functions from: $SHELL_FUNCTIONS_DIR"
source "$SHELL_FUNCTIONS_DIR/ansi.zsh"
source "$SHELL_FUNCTIONS_DIR/logging.zsh"
source "$SHELL_FUNCTIONS_DIR/misc.zsh"
source "$SHELL_FUNCTIONS_DIR/string.zsh"
source "$SHELL_FUNCTIONS_DIR/tau.zsh"


################################################################################
# Define other helper functions
################################################################################

gsc() {
  # Shallow git clone helper
  #
  # Arguments:
  #   * $1 : human-readable name
  #   * $2 : repository
  #   * $3 : directory
  #   * $4 : branch
  local name repo dir branch
  name="${1}"
  repo="${2}"
  dir="${3}"
  branch="${4:-}"

  if [[ -d "$dir" ]]; then
    if git -C "$dir" pull | grep -q "Already up to date"; then
      log_success "$name already installed and up to date!"
    else
      log_success "Updated $name..."
    fi
  elif [[ -z "$branch" ]]; then
    log_info "Installing $name..."
    git clone --depth=1 --single-branch "$repo" "$dir"
  else
    log_info "Installing $name..."
    git clone --depth=1 --single-branch --branch="$branch" "$repo" "$dir"
  fi
}

green-bold() {
  fg_green "$(bold "$1")"
}


################################################################################
# Ask for admin password upfront and keep updating the existing `sudo`
# timestamp on a background process until the script finishes. Note that
# you'll still need to use `sudo` where needed throughout the scripts.
################################################################################
log_warning "Some of the steps in this script require admin privileges.
Please enter your password now to avoid being prompted multiple times throughout the script."
sudo -v
while true; do
  sudo -n true
  sleep 30
  kill -0 "$$" || exit
done 2>/dev/null &


################################################################################
# Use Touch ID for sudo
################################################################################
./scripts/setup-touchid-for-sudo.zsh

################################################################################
# Command line developer tools
################################################################################
if xcode-select -p &>/dev/null; then
  log_success "Command Line Tools are already installed!"
else
  log_info "To install Command Line Tools, follow the instructions in the dialog box that will appear..."
  xcode-select --install
fi

################################################################################
# Homebrew
################################################################################
if cmd_exists brew; then
  log_success "Homebrew is already installed!"
elif cmd_exists /opt/homebrew/bin/brew; then
  log_info "Homebrew is already installed but was not found in the shell PATH. Setting up the shellenv..."
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  log_info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

################################################################################
# Xcode (install and accept the license agreement)
################################################################################
# Accepting the Xcode license agreement is a requirement for installing
# some of the software installed by this bootstrapping script.

# Install and use mas (https://github.com/mas-cli/mas)
# to install Xcode directly from the App Store
if ! cmd_exists mas; then
  brew install mas
fi
if mas list | grep -q "497799835"; then
  log_success "Xcode is already installed!"
else
  log_info "Installing Xcode from the App Store..."
  mas install 497799835
fi

if ! sudo xcodebuild -license status; then
  log_info "Accept the Xcode Apple SDK license agreement"
  sudo xcodebuild -license accept
else
  log_success "Xcode license agreement already accepted!"
fi

if ! sudo xcodebuild -checkFirstLaunchStatus; then
  log_info "Installing missing system components for Xcode..."
  sudo xcodebuild -runFirstLaunch
else
  log_success "No missing system components for Xcode!"
fi

################################################################################
# Brewfile dependencies
################################################################################
if brew bundle check --no-upgrade --no-lock --file=Mackup/.Brewfile &>/dev/null; then
  log_success "The Brewfile's dependencies are satisfied!"
else
  log_info "Installing Brewfile dependencies..."
  brew bundle --no-lock --no-upgrade --file=Mackup/.Brewfile
fi

alias ln='$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin/ln'
alias sudo-alias='sudo '


################################################################################
# Shell tools
################################################################################

PATH_TO_SHELL="${HOMEBREW_PREFIX}/bin/zsh"
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

gsc 'Powerlevel10k' \
  https://github.com/romkatv/powerlevel10k.git \
  "$ZSH_CUSTOM/themes/powerlevel10k"

gsc 'zsh-autosuggestions' \
  https://github.com/zsh-users/zsh-autosuggestions \
  "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

gsc 'zsh-syntax-highlighting' \
  https://github.com/zsh-users/zsh-syntax-highlighting.git \
  "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

gsc 'zsh-completions' \
  https://github.com/zsh-users/zsh-completions.git \
  "$ZSH_CUSTOM/plugins/zsh-completions"


if [[ -r "${HOME}/.iterm2_shell_integration.zsh" ]]; then
  log_success "Shell Integration and iTerm2 utilities already installed!"
else
  log_info "Installing Shell Integration and iTerm2 utilities..."
  curl -L https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | bash
fi


########################
# Python
########################
tau-install-multi "${TAU_VERSIONS:-3.8 3.9 3.10 3.11 3.12 3.13}"

# Install some global Python packages with 'uv tool' (uvx)
_uvx_packages_to_install=('poetry' 'pipenv' 'cookiecutter' 'argcomplete' 'ssh-audit')
for package in "${_uvx_packages_to_install[@]}"; do
  if uv tool list | grep -q "$package"; then
    log_success "${package} is already installed!"
  else
    log_info "Installing $package..."
    uv tool install "$package"
  fi
done

# Install poetry completions
POETRY_OMZ_PLUGIN_PATH="$ZSH_CUSTOM/plugins/poetry"
if [[ -d "$POETRY_OMZ_PLUGIN_PATH" ]]; then
  log_success "poetry shell completions already installed!"
else
  log_info "Installing poetry shell completions..."
  mkdir -p "$POETRY_OMZ_PLUGIN_PATH"
  "$HOME/.local/bin/poetry" completions zsh > "$POETRY_OMZ_PLUGIN_PATH/_poetry"
fi

# Create playground venv
PY_PLAYGROUND_VENV="${HOME}/.venv"
if [[ -d "$PY_PLAYGROUND_VENV" ]]; then
  log_success "Playground Python venv already exists at: $PY_PLAYGROUND_VENV"
else
  log_info "Creating playground Python venv at: $PY_PLAYGROUND_VENV"
  uv venv --python=3.13 "$PY_PLAYGROUND_VENV"
fi


########################
# Setup ssh
########################
./scripts/setup-ssh.zsh


########################
# GitHub CLI
########################

_gh_extensions_to_install=('github/gh-copilot' 'yusukebe/gh-markdown-preview' 'dlvhdr/gh-dash')
_install_gh_extensions() {
  for extension in "${_gh_extensions_to_install[@]}"; do
    if gh extension list | grep -q "$extension"; then
      log_success "GitHub CLI extension $extension is already installed!"
    else
      log_info "Installing GitHub CLI extension $extension..."
      gh extension install "$extension"
    fi
  done
}

if gh auth status &>/dev/null; then
  _install_gh_extensions
else
  msg="To get started with the GitHub CLI and install some useful extensions, you need to authenticate first. Do you want to do that now?"
  if ask-yesno "$msg"; then
    log_info "Please follow the interactive instructions bellow:"
    gh auth login
    _install_gh_extensions
  else
    log_warning "Skipping... If you're interested, you will have to install the following GitHub CLI extensions yourself: ${_gh_extensions_to_install[*]}"
  fi
fi


########################
# Misc
########################

if git -C "$HOME" lfs env | grep -q "git-lfs clean -- %f"; then
  log_success "git-lfs is already installed!"
else
  log_info "Installing git-lfs globally..."
  git -C "$HOME" lfs install
fi

if [[ -d "$HOME/.cargo/bin" ]]; then
  log_success "Rust already installed!"
else
  log_info "Installing Rust..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path --verbose -y
fi

# https://flutter.dev/docs/get-started/install/macos
if [[ -d "$HOME/.flutter/bin" ]]; then
  log_success "Flutter and Dart already installed!"
else
  softwareupdate --install-rosetta --agree-to-license
  gsc 'Flutter and Dart' https://github.com/flutter/flutter.git "$HOME/.flutter" stable
  "$HOME/.flutter/bin/flutter" doctor
fi

gsc "Sublime Text's 'One Dark' theme" \
  https://github.com/andresmichel/one-dark-theme.git \
  "$HOME/Library/Application Support/Sublime Text/Packages/Theme - One Dark"

if [[ -r /usr/local/bin/gh-md-toc ]]; then
  log_success "github-markdown-toc is already installed!"
else
  log_info "Install github-markdown-toc..."
  curl https://raw.githubusercontent.com/ekalinin/github-markdown-toc/master/gh-md-toc -o gh-md-toc
  sudo mv gh-md-toc /usr/local/bin
  chmod a+x /usr/local/bin/gh-md-toc
fi

if [[ -r "$HOME/go/bin/gollama" ]]; then
  log_success "gollama is already installed!"
else
  log_info "Installing gollama..."
  go install github.com/sammcj/gollama@HEAD
fi


################################################################################
# Extra config steps
################################################################################
log_info "Performing final config steps..."

log_info "Symlinking the openjdk JDK (exposing it to the system Java wrappers)"
sudo-alias ln -snfTv "${HOMEBREW_PREFIX}/opt/openjdk@11/libexec/openjdk.jdk" "/Library/Java/JavaVirtualMachines/openjdk-11.jdk"

log_info "Creating bin/ and src/ directories for Golang..."
mkdir -p "$HOME/go/bin" "$HOME/go/src"

log_info "Restoring application settings (using Mackup)..."
ln -snfTv "$(realpath .mackup.cfg)" "$HOME/.mackup.cfg"
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
log_warning "It's usually recommended to reboot your machine after running this script."
if ask-yesno "Do you want to reboot?"; then
  echo "Rebooting in..."
  for i in {3..1}; do
    echo "$i"
    sleep 1
  done
  echo "Bye!"
  sudo shutdown -r now
fi
