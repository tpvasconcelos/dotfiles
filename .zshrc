# shellcheck disable=SC1090,SC2034
########################################
# .zshrc: interactive shell settings
########################################


################################################################################
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
################################################################################
load "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"


################################################################################
# Path to your oh-my-zsh installation.
################################################################################
export ZSH="${HOME}/.oh-my-zsh"


################################################################################
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
################################################################################
#ZSH_THEME="random"
ZSH_THEME="powerlevel10k/powerlevel10k"


################################################################################
# Load plugins
################################################################################
load "${SHELL_DIR_INTERACTIVE}/sources/oncall/plugins.zsh"


################################################################################
# Load om-my-zsh
################################################################################
load "${ZSH}/oh-my-zsh.sh"


################################################################################
# Define aliases
################################################################################
alias ls='ls -G -la'
alias pp='echo $PATH | tr -s ":" "\n"'
alias pag='ps aux | head -1; ps aux | grep -v grep | grep'
eval "$(thefuck --alias)"


################################################################################
# Add some CPP and LDF flags, and PKG_CONFIG_PATH paths
################################################################################
## openssl
#export LDFLAGS="-L${BREW_PREFIX}/opt/openssl@1.1/lib"
#export CPPFLAGS="-I${BREW_PREFIX}/opt/openssl@1.1/include"
#export PKG_CONFIG_PATH="${BREW_PREFIX}/opt/openssl@1.1/lib/pkgconfig"
## readline
#export LDFLAGS="-L${BREW_PREFIX}/opt/readline/lib"
#export CPPFLAGS="-I${BREW_PREFIX}/opt/readline/include"
#export PKG_CONFIG_PATH="${BREW_PREFIX}/opt/readline/lib/pkgconfig"
## sqlite
#export LDFLAGS="-L${BREW_PREFIX}/opt/sqlite/lib"
#export CPPFLAGS="-I${BREW_PREFIX}/opt/sqlite/include"
#export PKG_CONFIG_PATH="${BREW_PREFIX}/opt/sqlite/lib/pkgconfig"
## llvm
#export LDFLAGS="-L${BREW_PREFIX}/opt/llvm/lib"
#export CPPFLAGS="-I${BREW_PREFIX}/opt/llvm/include"
## zlib
#export LDFLAGS="-L${BREW_PREFIX}/opt/llvm/lib -Wl,-rpath,${BREW_PREFIX}/opt/llvm/lib"
#export LDFLAGS="-L${BREW_PREFIX}/opt/zlib/lib"
#export CPPFLAGS="-I${BREW_PREFIX}/opt/zlib/include"
#export PKG_CONFIG_PATH="${BREW_PREFIX}/opt/zlib/lib/pkgconfig"
## ruby
#export LDFLAGS="-L${BREW_PREFIX}/opt/ruby/lib"
#export CPPFLAGS="-I${BREW_PREFIX}/opt/ruby/include"
#export PKG_CONFIG_PATH="${BREW_PREFIX}/opt/ruby/lib/pkgconfig"
# Merged  ---
export LDFLAGS="-L${BREW_PREFIX}/opt/openssl@1.1/lib -L${BREW_PREFIX}/opt/readline/lib -L${BREW_PREFIX}/opt/sqlite/lib -L${BREW_PREFIX}/opt/llvm/lib -L${BREW_PREFIX}/opt/zlib/lib -L${BREW_PREFIX}/opt/ruby/lib"
export CPPFLAGS="-I${BREW_PREFIX}/opt/openssl@1.1/include -I${BREW_PREFIX}/opt/readline/include -I${BREW_PREFIX}/opt/sqlite/include -I${BREW_PREFIX}/opt/llvm/include -I${BREW_PREFIX}/opt/zlib/include -I${BREW_PREFIX}/opt/ruby/include"
export PKG_CONFIG_PATH="${BREW_PREFIX}/opt/openssl@1.1/lib/pkgconfig:${BREW_PREFIX}/opt/readline/lib/pkgconfig:${BREW_PREFIX}/opt/sqlite/lib/pkgconfig:${BREW_PREFIX}/opt/zlib/lib/pkgconfig:${BREW_PREFIX}/opt/ruby/lib/pkgconfig"


################################################################################
# Guile
################################################################################
export GUILE_LOAD_PATH="${BREW_PREFIX}/share/guile/site/3.0"
export GUILE_LOAD_COMPILED_PATH="${BREW_PREFIX}/lib/guile/3.0/site-ccache"
export GUILE_SYSTEM_EXTENSIONS_PATH="${BREW_PREFIX}/lib/guile/3.0/extensions"
export GUILE_TLS_CERTIFICATE_DIRECTORY="${BREW_PREFIX}/etc/gnutls/"


################################################################################
# pyenv
################################################################################
PYENV_ROOT=$(pyenv root)
export PYENV_ROOT
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi


################################################################################
# Ruby
################################################################################
export PATH="${BREW_PREFIX}/opt/ruby/bin:${PATH}"
export PATH="/Users/tpvasconcelos/.gem/ruby/3.0.0/bin:${PATH}"
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=${BREW_PREFIX}/opt/openssl@1.1"


################################################################################
# Load some custom functions
################################################################################
for dotscript in "${SHELL_DIR_INTERACTIVE}"/functions/*(.); do
  load "$dotscript"
done


################################################################################
# iTerm2 Shell Integration
################################################################################
load "${HOME}/.iterm2_shell_integration.zsh"


################################################################################
# Customize shell prompt
# To customize prompt, run `p10k configure` or edit .p10k.zsh
################################################################################
load "${SHELL_DIR_INTERACTIVE}/sources/oncall/.p10k.zsh"
