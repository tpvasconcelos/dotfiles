# shellcheck disable=SC2034,SC1090
########################################
# .zshenv: zsh environment settings
########################################

# The path to the ~/.dotfiles directory needs to be known
# a priori since all other configs live under this path!
export DOTFILES="${HOME}/.dotfiles"

# load configs
for dotscript in "${DOTFILES}"/shell/sources/environment/*(.); do
  source "$dotscript"
done

# load functions
for dotscript in "${DOTFILES}"/shell/functions/environment/*(.); do
  source "$dotscript"
done
