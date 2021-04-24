# shellcheck disable=SC1090
########################################
# .zshenv: zsh environment settings
########################################

# Fast path to the brew prefix ---> $(brew --prefix)
# This variable is exported first because it's
# used by several of the following scripts
BREW_PREFIX="/usr/local"
export BREW_PREFIX

DOTFILES_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export DOTFILES_DIR

export SHELL_DIR_ENVIRONMENT="${DOTFILES_DIR}/shell/environment"
export SHELL_DIR_INTERACTIVE="${DOTFILES_DIR}/shell/interactive"

# Load core functions  ---
# These have to be sourced first since I use some
# on the utils defined here in the upcoming steps
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


# Load configs
for dotscript in "${SHELL_DIR_ENVIRONMENT}"/sources/*(.); do
  load "$dotscript"
done

# Load functions
#for dotscript in "${SHELL_DIR_ENVIRONMENT}"/functions/*(.); do
#  source "$dotscript"
#done
