# shellcheck disable=SC2034,SC1090
########################################
# .zshenv: zsh environment settings
########################################

# The path to the ~/.dotfiles directory needs to be known
# a priori since all other configs live under this path!
export DOTFILES="${HOME}/.dotfiles"

source_if_exists() {
  # If file exists (and is readable), source it. Else, print an error message.
  # alternative names: import, include
  if [[ -r "${1}" ]]; then
    source "${1}"
  else
    print "Couldn't source '${1}'. File does not exist!"
  fi
}

# Load configs
for dotscript in "${DOTFILES}"/shell/sources/environment/*(.); do
  source_if_exists "$dotscript"
done

# Load functions
for dotscript in "${DOTFILES}"/shell/functions/environment/*(.); do
  source_if_exists "$dotscript"
done
