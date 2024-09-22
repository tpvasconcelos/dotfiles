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
_ZSHENV_LOADED=1

################################################################################
# Export some environment (ENV) variables
################################################################################

DOTFILES_DIR="$(dirname "$(dirname "$(readlink "${HOME}/.zshenv")")")"
export DOTFILES_DIR
export SHELL_DIR_FUNCTIONS="$DOTFILES_DIR/shell/functions"
export SHELL_DIR_INTERACTIVE="$DOTFILES_DIR/shell/interactive"
export SHELL_DIR_EXTRA_STARTUP_SCRIPTS="$DOTFILES_DIR/shell/extra_startup_scripts"

# Fast path to the brew prefix: "$(brew --prefix)"
export BREW_PREFIX="/opt/homebrew"

# Python stuff ---
export PY_PLAYGROUND_VENV="$HOME/.venv"
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
  /usr/local/texlive/*/bin/universal-darwin
  "$BREW_PREFIX/sbin"
  "$BREW_PREFIX/opt/coreutils/libexec/gnubin"
  "$BREW_PREFIX/opt/findutils/libexec/gnubin"
  "$BREW_PREFIX/opt/gnu-sed/libexec/gnubin"
  "$BREW_PREFIX/opt/gnu-tar/libexec/gnubin"
  "$BREW_PREFIX/opt/grep/libexec/gnubin"
  "$BREW_PREFIX/opt/llvm/bin"
  "$BREW_PREFIX/opt/openjdk@11/bin"
  "$BREW_PREFIX/opt/ruby/bin"
  "$BREW_PREFIX/opt/dotnet@6/bin"
  "$HOME/.cargo/bin"
  "$HOME/.deta/bin"
  "$HOME/.flutter/bin"
  "$HOME/.gem/ruby/3.2.0/bin"
  "$HOME/.local/bin"
  "$HOME/.poetry/bin"
  "$HOME/.dotnet/tools"
  "$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
  "$GOPATH/bin"
  "$JAVA_HOME/bin"
  "${KREW_ROOT:-$HOME/.krew}/bin"
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
  "$BREW_PREFIX/share/zsh/site-functions"
  "${fpath[@]}"
)
export fpath
typeset -U fpath

# autoload all custom functions
#autoload -Uz "${SHELL_DIR_FUNCTIONS}"/**/*(.:t)

# Source custom functions scripts  ---
for function_script in "$SHELL_DIR_FUNCTIONS"/*(.); do
  source "$function_script"
done

################################################################################
# If exists, run the extra local startup script
################################################################################
if [[ -r "$SHELL_DIR_EXTRA_STARTUP_SCRIPTS/.zshenv" ]]; then
  source "$SHELL_DIR_EXTRA_STARTUP_SCRIPTS/.zshenv"
fi
