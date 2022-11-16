# shellcheck disable=SC1090,SC2034
#
# .zshrc startup script --> interactive shell settings
#
# .zshrc is sourced in interactive shells.  It
# should contain commands to set up aliases, functions,
# options, key bindings, etc.
#


################################################################################
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
################################################################################
source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"


################################################################################
# Oh-my-zsh!
################################################################################

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Load plugins
source "${SHELL_DIR_INTERACTIVE}/plugins.zsh"

# Load om-my-zsh
source "${ZSH}/oh-my-zsh.sh"


################################################################################
# Shell History Configuration
################################################################################
HISTFILE="$HOME/.zsh_history" # Where to save history to disk
HISTSIZE=10000                # How many lines of history to keep in memory
SAVEHIST=10000                # Number of history entries to save to disk
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
# Define aliases
################################################################################
alias ls='ls -G -la'
alias pp='echo $PATH | tr -s ":" "\n"'
alias pag='ps aux | head -1; ps aux | grep -v grep | grep -i'
alias wa='watch -c '
alias p='pycharm .'
eval "$(thefuck --alias)"


################################################################################
# Set LDFLAGS, CPPFLAGS, and PKG_CONFIG_PATH
################################################################################

## openssl@3
#export LDFLAGS="-L${BREW_PREFIX}/opt/openssl@3/lib ${LDFLAGS}"
#export CPPFLAGS="-I${BREW_PREFIX}/opt/openssl@3/include ${CPPFLAGS}"
#export PKG_CONFIG_PATH="${BREW_PREFIX}/opt/openssl@3/lib/pkgconfig:${PKG_CONFIG_PATH}"

# openssl@1.1
export LDFLAGS="-L${BREW_PREFIX}/opt/openssl@1.1/lib ${LDFLAGS}"
export CPPFLAGS="-I${BREW_PREFIX}/opt/openssl@1.1/include ${CPPFLAGS}"
export PKG_CONFIG_PATH="${BREW_PREFIX}/opt/openssl@1.1/lib/pkgconfig:${PKG_CONFIG_PATH}"

# openblas
export LDFLAGS="-L${BREW_PREFIX}/opt/openblas/lib ${LDFLAGS}"
export CPPFLAGS="-I${BREW_PREFIX}/opt/openblas/include ${CPPFLAGS}"
export PKG_CONFIG_PATH="${BREW_PREFIX}/opt/openblas/lib/pkgconfig:${PKG_CONFIG_PATH}"

# readline
export LDFLAGS="-L${BREW_PREFIX}/opt/readline/lib ${LDFLAGS}"
export CPPFLAGS="-I${BREW_PREFIX}/opt/readline/include ${CPPFLAGS}"
export PKG_CONFIG_PATH="${BREW_PREFIX}/opt/readline/lib/pkgconfig:${PKG_CONFIG_PATH}"

# sqlite
export LDFLAGS="-L${BREW_PREFIX}/opt/sqlite/lib ${LDFLAGS}"
export CPPFLAGS="-I${BREW_PREFIX}/opt/sqlite/include ${CPPFLAGS}"
export PKG_CONFIG_PATH="${BREW_PREFIX}/opt/sqlite/lib/pkgconfig:${PKG_CONFIG_PATH}"

# llvm
export LDFLAGS="-L${BREW_PREFIX}/opt/llvm/lib ${LDFLAGS}"
export CPPFLAGS="-I${BREW_PREFIX}/opt/llvm/include ${CPPFLAGS}"
# libc++
export LDFLAGS="-L${BREW_PREFIX}/opt/llvm/lib/c++ -Wl,-rpath,${BREW_PREFIX}/opt/llvm/lib/c++ ${LDFLAGS}"

# libomp
export LDFLAGS="-L${BREW_PREFIX}/opt/libomp/lib ${LDFLAGS}"
export CPPFLAGS="-I${BREW_PREFIX}/opt/libomp/include ${CPPFLAGS}"

# gcc
export LDFLAGS="-L${BREW_PREFIX}/opt/gcc/lib/gcc/12 ${LDFLAGS}"
export CPPFLAGS="-I${BREW_PREFIX}/opt/gcc/include/c++/12 ${CPPFLAGS}"

# ruby
export LDFLAGS="-L${BREW_PREFIX}/opt/ruby/lib ${LDFLAGS}"
export CPPFLAGS="-I${BREW_PREFIX}/opt/ruby/include ${CPPFLAGS}"
export PKG_CONFIG_PATH="${BREW_PREFIX}/opt/ruby/lib/pkgconfig:${PKG_CONFIG_PATH}"

# openjdk (Java)
export CPPFLAGS="-I${BREW_PREFIX}/opt/openjdk@11/include ${CPPFLAGS}"


################################################################################
# Misc
################################################################################

# Guile  ---
export GUILE_LOAD_PATH="${BREW_PREFIX}/share/guile/site/3.0"
export GUILE_LOAD_COMPILED_PATH="${BREW_PREFIX}/lib/guile/3.0/site-ccache"
export GUILE_SYSTEM_EXTENSIONS_PATH="${BREW_PREFIX}/lib/guile/3.0/extensions"
export GUILE_TLS_CERTIFICATE_DIRECTORY="${BREW_PREFIX}/etc/gnutls/"

# pyenv  ---
eval "$(pyenv init -)"

# Ruby  ---
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=${BREW_PREFIX}/opt/openssl@1.1"


################################################################################
# If exists, run the extra local startup script
################################################################################
if [[ -r "${SHELL_DIR_EXTRA_STARTUP_SCRIPTS}/.zshrc.extra" ]]; then
  source "${SHELL_DIR_EXTRA_STARTUP_SCRIPTS}/.zshrc.extra"
fi


################################################################################
# iTerm2 Shell Integration
################################################################################
source "${HOME}/.iterm2_shell_integration.zsh"


################################################################################
# Customize shell prompt
# To customize prompt, run `p10k configure` or edit .p10k.zsh
################################################################################
source "${SHELL_DIR_INTERACTIVE}/.p10k.zsh"
