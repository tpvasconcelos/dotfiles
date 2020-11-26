# shellcheck disable=SC1090,SC2034
########################################
# .zshrc: interactive shell settings
########################################

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

# Fast path to the brew prefix ---> /usr/local
# This variable is exported first because it's
# used by several of the following scripts
BREW_PREFIX="$(brew --prefix)"
export BREW_PREFIX

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="random"
ZSH_THEME="powerlevel10k/powerlevel10k"

source "${DOTFILES}/shell/sources/interactive/oncall/plugins"

source "${ZSH}/oh-my-zsh.sh"
source "${HOME}/.iterm2_shell_integration.zsh"

# load configs
for dotscript in "${DOTFILES}"/shell/sources/interactive/*(.); do
  source "$dotscript"
done

# load functions
for dotscript in "${DOTFILES}"/shell/functions/interactive/*(.); do
  source "$dotscript"
done

# To customize prompt, run `p10k configure` or edit .p10k.zsh.
source "${DOTFILES}/shell/sources/interactive/oncall/.p10k.zsh"
