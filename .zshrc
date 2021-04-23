# shellcheck disable=SC1090,SC2034
########################################
# .zshrc: interactive shell settings
########################################

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
load "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="random"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Load plugins
load "${SHELL_DIR_INTERACTIVE}/sources/oncall/plugins.zsh"

# Load om-my-zsh
load "${ZSH}/oh-my-zsh.sh"

# Load configs
for dotscript in "${SHELL_DIR_INTERACTIVE}"/sources/*(.); do
  load "$dotscript"
done

# Load functions
for dotscript in "${SHELL_DIR_INTERACTIVE}"/functions/*(.); do
  load "$dotscript"
done

load "${HOME}/.iterm2_shell_integration.zsh"

# To customize prompt, run `p10k configure` or edit .p10k.zsh.
load "${SHELL_DIR_INTERACTIVE}/sources/oncall/.p10k.zsh"
