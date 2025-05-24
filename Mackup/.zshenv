# shellcheck disable=SC1090,SC2034
#
# .zshenv startup script --> environment settings
#
# .zshenv is sourced on ALL invocations of the shell, unless the -f option is
# set.  It should NOT normally contain commands to set the command search path,
# or other common environment variables unless you really know what you're
# doing.  E.g. running "PATH=/custom/path gdb program" sources this file (when
# gdb runs the program via $SHELL), so you want to be sure not to override a
# custom environment in such cases.  Note also that .zshenv should not contain
# commands that produce output or assume the shell is attached to a tty.
#
_ZSHENV_LOADED=true
_ZPROFILE_LOADED=false
_ZSHRC_LOADED=false

################################################################################
# Export some environment (ENV) variables
################################################################################

# FIXME: This doesn't work anymore because we stopped using Mackup's symlinks...
# DOTFILES_DIR="$(dirname "$(dirname "$(readlink "${HOME}/.zshenv")")")"
DOTFILES_DIR="$HOME/.dotfiles"
export DOTFILES_DIR
export SHELL_DIR_FUNCTIONS="$DOTFILES_DIR/shell/functions"
export SHELL_DIR_INTERACTIVE="$DOTFILES_DIR/shell/interactive"
export SHELL_DIR_EXTRA_STARTUP_SCRIPTS="$DOTFILES_DIR/shell/extra_startup_scripts"

# This exports HOMEBREW_PREFIX, HOMEBREW_CELLAR,
# HOMEBREW_REPOSITORY, MANPATH, INFOPATH, and
# appends homebrew-managed bins to PATH,
# and exports some other variables.
eval "$(/opt/homebrew/bin/brew shellenv)"

# Python stuff ---
export PY_PLAYGROUND_VENV="$HOME/.venvs/.venv"
export PIPENV_VERBOSITY=-1
# Creates .venv in your project directory. Default is to
# create  new virtual environments in a global location
export PIPENV_VENV_IN_PROJECT=1

# Misc ---
JAVA_HOME="$(/usr/libexec/java_home)"
export JAVA_HOME
export GOPATH="$HOME/go"

# locale settings
export LC_ALL='en_US.UTF-8'
export LANG='en_US.UTF-8'

################################################################################
# Add some bins to PATH
################################################################################
_ZSHENV_PATH_EXTRAS=(
  # Add our tau shims to the top of the PATH to make sure our
  # Python executables are used instead of the system, brew
  # pyenv, uv, or any other Python/pip installations...
  "${TAU_ROOT:-${HOME}/.tau}/shims"
  # The Homebrew-managed bins should come right at the top too
  "$HOMEBREW_PREFIX/bin"
  "$HOMEBREW_PREFIX/sbin"
  # Then everything else...
  "$HOMEBREW_PREFIX/opt/uutils-coreutils/libexec/uubin"
  "$HOMEBREW_PREFIX/opt/uutils-findutils/libexec/uubin"
  "$HOMEBREW_PREFIX/opt/uutils-diffutils/libexec/uubin"
  "$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin"
  "$HOMEBREW_PREFIX/opt/gnu-tar/libexec/gnubin"
  "$HOMEBREW_PREFIX/opt/grep/libexec/gnubin"
  "$HOMEBREW_PREFIX/opt/llvm/bin"
  "$HOMEBREW_PREFIX/opt/openjdk@11/bin"
  "$HOMEBREW_PREFIX/opt/ruby/bin"
  "$HOMEBREW_PREFIX"/lib/ruby/gems/*/bin
  "$HOME/.cargo/bin"
  "$HOME/.flutter/bin"
  "$HOME/.gem/bin"
  "$HOME/.lmstudio/bin"
  "$HOME/.local/bin"
  "$HOME/.poetry/bin"
  "$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
  "$GOPATH/bin"
  "$JAVA_HOME/bin"
  "${KREW_ROOT:-$HOME/.krew}/bin"
  # Do not quote the following path!! (note the globbing)
  /usr/local/texlive/*/bin/universal-darwin
)
path=(
  "${_ZSHENV_PATH_EXTRAS[@]}"
  "${path[@]}"
)
export PATH
typeset -U PATH path

################################################################################
# Path to search for auto-loadable functions
################################################################################
fpath=(
  #"${SHELL_DIR_FUNCTIONS}"/**/
  "$HOME/.zfunc"
  "$HOMEBREW_PREFIX/share/zsh/site-functions"
  "${fpath[@]}"
)
export fpath
typeset -U fpath

# autoload all custom functions
#autoload -Uz "${SHELL_DIR_FUNCTIONS}"/**/*(.:t)

# Source custom functions scripts  ---
_zshenv::source_custom_functions() {
  for function_script in "$SHELL_DIR_FUNCTIONS"/*(.); do
    source "$function_script"
  done
}
_zshenv::source_custom_functions

################################################################################
# If exists, run the extra local startup script
################################################################################
if [[ -r "$SHELL_DIR_EXTRA_STARTUP_SCRIPTS/.zshenv" ]]; then
  source "$SHELL_DIR_EXTRA_STARTUP_SCRIPTS/.zshenv"
fi
