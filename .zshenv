# shellcheck disable=SC1090
########################################
# .zshenv: zsh environment settings
########################################

# The path to the ~/.dotfiles directory needs to be known
# a priori since all other configs live under this path!
export DOTFILES="${HOME}/.dotfiles"

export SHELL_DIR_ENVIRONMENT="${DOTFILES}/shell/environment"
export SHELL_DIR_INTERACTIVE="${DOTFILES}/shell/interactive"

# Load core functions  ---
# These have to be sourced first since I use some
# on the utils defined here in the upcoming steps
source "${SHELL_DIR_ENVIRONMENT}/functions/oncall/ansi"
source "${SHELL_DIR_ENVIRONMENT}/functions/oncall/logging"
source "${SHELL_DIR_ENVIRONMENT}/functions/oncall/sourcing"
loaded_scripts=(
  "${SHELL_DIR_ENVIRONMENT}/functions/oncall/ansi"
  "${SHELL_DIR_ENVIRONMENT}/functions/oncall/logging"
  "${SHELL_DIR_ENVIRONMENT}/functions/oncall/sourcing"
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
