# shellcheck disable=SC1090
###############################################
# .zshenv: zsh environment settings
###############################################

################################################################################
# Export some environment (ENV) variables
################################################################################

# Fast path to the brew prefix ---> $(brew --prefix)
export BREW_PREFIX="/usr/local"

DOTFILES_DIR="$(dirname "$(readlink "$HOME/.zshenv")")"
export DOTFILES_DIR

export SHELL_DIR_FUNCTIONS="${DOTFILES_DIR}/shell/functions"
export SHELL_DIR_INTERACTIVE="${DOTFILES_DIR}/shell/interactive"

# Misc ---
export GOPATH="${HOME}/go"
export LANG="en_US.UTF-8"
export PYENV_TARGET_VERSIONS=("3.7" "3.8" "3.9")
export GREP_COLOR='1;33'
export JAVA_HOME="$(/usr/libexec/java_home)"


################################################################################
# Add some bins to PATH
################################################################################
path=(
  # ${BREW_PREFIX}/anaconda3/bin"
  "${BREW_PREFIX}/opt/coreutils/libexec/gnubin"
  "${BREW_PREFIX}/opt/openjdk@8/bin"
  "${BREW_PREFIX}/sbin"
  "${GOPATH}/bin"
  "${HOME}/.deta/bin"
  "${HOME}/.flutter/bin"
  "${HOME}/.local/bin"
  "${HOME}/.poetry/bin"
  "${JAVA_HOME}/bin"
  "${KREW_ROOT:-$HOME/.krew}/bin"
  "${path[@]}"
)
export PATH
typeset -U PATH path

################################################################################
# Path to search for auto-loadable functions
################################################################################
fpath=(
  #"${SHELL_DIR_FUNCTIONS}"/**/
  "${BREW_PREFIX}/share/zsh/site-functions"
  "${fpath[@]}"
)
export fpath
typeset -U fpath

# autoload all custom functions
#autoload -Uz "${SHELL_DIR_FUNCTIONS}"/**/*(.:t)

# Source custom functions scripts  ---
for function_script in "${SHELL_DIR_FUNCTIONS}"/*(.); do
  source "$function_script"
done
