# shellcheck disable=SC1090
###############################################
# .zshenv: zsh environment settings
###############################################


################################################################################
# Export some environment (ENV) variables
################################################################################

# Fast path to the brew prefix ---> $(brew --prefix)
export BREW_PREFIX="/usr/local"

DOTFILES_DIR="$(dirname "$(readlink .zshenv)")"
export DOTFILES_DIR

export SHELL_DIR_ENVIRONMENT="${DOTFILES_DIR}/shell/environment"
export SHELL_DIR_INTERACTIVE="${DOTFILES_DIR}/shell/interactive"

# Misc ---
export GOPATH="${HOME}/go"
export LANG="en_US.UTF-8"
export PYENV_TARGET_VERSIONS=("2.7" "3.7" "3.8" "3.9" "3.10")
export GREP_COLOR='1;33'


################################################################################
# Shell History Configuration
################################################################################
HISTFILE=~/.zsh_history       # Where to save history to disk
HISTSIZE=4096                 # How many lines of history to keep in memory
SAVEHIST=4096                 # Number of history entries to save to disk
HISTDUP=erase                 # Erase duplicates in the history file
setopt appendhistory          # Append history to the history file (no overwriting)
setopt INC_APPEND_HISTORY     # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY          # Share history between all sessions.
setopt BANG_HIST              # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY       # Write the history file in the ":start:elapsed;command" format.
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS       # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS   # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS      # Do not display a line previously found.
setopt HIST_IGNORE_SPACE      # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS      # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS     # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY            # Don't execute immediately upon history expansion.
setopt HIST_BEEP              # Beep when accessing nonexistent history.
export ERL_AFLAGS="-kernel shell_history enabled"


################################################################################
# Add some bins to PATH
################################################################################
path=(
  "${BREW_PREFIX}/opt/coreutils/libexec/gnubin"
  "${BREW_PREFIX}/sbin"
  "${HOME}/.flutter/bin"
  "${HOME}/.poetry/bin"
  "${GOPATH}/bin"
  "${path[@]}"
)
export PATH
typeset -U PATH path


################################################################################
# Path to search for auto-loadable functions
################################################################################
fpath=(
  "${BREW_PREFIX}/share/zsh/site-functions"
  "${fpath[@]}"
)
export fpath
typeset -U fpath


################################################################################
# Load some custom functions
################################################################################
source "${SHELL_DIR_ENVIRONMENT}/functions/oncall/ansi.zsh"
source "${SHELL_DIR_ENVIRONMENT}/functions/oncall/logging.zsh"
source "${SHELL_DIR_ENVIRONMENT}/functions/oncall/sourcing.zsh"
loaded_scripts=(
  "${SHELL_DIR_ENVIRONMENT}/functions/oncall/ansi.zsh"
  "${SHELL_DIR_ENVIRONMENT}/functions/oncall/logging.zsh"
  "${SHELL_DIR_ENVIRONMENT}/functions/oncall/sourcing.zsh"
)
export loaded_scripts
typeset -U loaded_scripts


# Load functions  ---
#for dotscript in "${SHELL_DIR_ENVIRONMENT}"/functions/*(.); do
#  source "$dotscript"
#done
