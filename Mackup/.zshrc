# shellcheck disable=SC1090,SC2034
#
# .zshrc startup script --> interactive shell settings
#
# .zshrc is sourced in interactive shells.  It
# should contain commands to set up aliases, functions,
# options, key bindings, etc.
#
_ZSHRC_LOADED=true

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

# Set name of the theme to load
# ref: https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Load plugins
source "${SHELL_DIR_INTERACTIVE}/plugins.zsh"

# Disable auto-update
zstyle ':omz:update' mode disabled

# Load om-my-zsh
source "${ZSH}/oh-my-zsh.sh"


################################################################################
# Zsh shell options
# https://zsh.sourceforge.io/Doc/Release/Options.html
################################################################################

# Changing Directories ---
setopt AUTO_CD                  # cd if a cmd can't be executed and is the name of a directory.

# History ---
setopt APPEND_HISTORY           # Append history to the history file (no overwriting).
setopt INC_APPEND_HISTORY       # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY            # Share history between all sessions.
setopt BANG_HIST                # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY         # Write the history file in the ":start:elapsed;command" format.
setopt HIST_EXPIRE_DUPS_FIRST   # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS         # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS     # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS        # Do not display a line previously found.
setopt HIST_IGNORE_SPACE        # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS        # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS       # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY              # Don't execute immediately upon history expansion.
HISTFILE="$HOME/.zsh_history"   # Where to save history to disk.
HISTSIZE=50000                  # How many lines of history to keep in memory.
SAVEHIST=50000                  # Number of history entries to save to disk.
HISTDUP=erase                   # Erase duplicates in the history file.
export ERL_AFLAGS="-kernel shell_history enabled"

# Zle ---
setopt NO_BEEP                  # Disable beep on error.

# Completion ---
setopt AUTO_LIST                # Automatically list choices on ambiguous completion.
setopt AUTO_MENU                # Automatically use menu completion after the second consecutive request.
setopt MENU_COMPLETE            # Automatically complete the text of the line when possible.
setopt NO_LIST_AMBIGUOUS        # Do not list all possible completions without regard to the current context.
# Enable zsh-completions
# see:
# * https://github.com/zsh-users/zsh-completions?tab=readme-ov-file#oh-my-zsh
# * https://github.com/zsh-users/zsh-completions/issues/603
fpath+="${ZSH_CUSTOM:-"$ZSH/custom"}/plugins/zsh-completions/src"
# Load completions
autoload -Uz compinit; compinit
# Configure completions style
zstyle ':completion:*' menu yes select
# Load pyenv completions
source /opt/homebrew/Cellar/pyenv/*/completions/pyenv.zsh
# Load uv's completions
eval "$(uv generate-shell-completion zsh)"
# TODO: Migrate to uvx?
## Load uvx's completions
#eval "$(uvx --generate-shell-completion zsh)"


################################################################################
# Define aliases
################################################################################
alias ls='gls --color=auto -la'
alias pp='echo $PATH | tr -s ":" "\n"'
alias pag='ps aux | head -1; ps aux | grep -v grep | grep -i'
alias wa='watch -c '
alias p='pycharm .'


################################################################################
# Set LDFLAGS, CPPFLAGS, and PKG_CONFIG_PATH
################################################################################

# openblas
export LDFLAGS="-L${HOMEBREW_PREFIX}/opt/openblas/lib ${LDFLAGS}"
export CPPFLAGS="-I${HOMEBREW_PREFIX}/opt/openblas/include ${CPPFLAGS}"
export PKG_CONFIG_PATH="${HOMEBREW_PREFIX}/opt/openblas/lib/pkgconfig:${PKG_CONFIG_PATH}"

# readline
export LDFLAGS="-L${HOMEBREW_PREFIX}/opt/readline/lib ${LDFLAGS}"
export CPPFLAGS="-I${HOMEBREW_PREFIX}/opt/readline/include ${CPPFLAGS}"
export PKG_CONFIG_PATH="${HOMEBREW_PREFIX}/opt/readline/lib/pkgconfig:${PKG_CONFIG_PATH}"

# sqlite
export LDFLAGS="-L${HOMEBREW_PREFIX}/opt/sqlite/lib ${LDFLAGS}"
export CPPFLAGS="-I${HOMEBREW_PREFIX}/opt/sqlite/include ${CPPFLAGS}"
export PKG_CONFIG_PATH="${HOMEBREW_PREFIX}/opt/sqlite/lib/pkgconfig:${PKG_CONFIG_PATH}"

# llvm
export LDFLAGS="-L${HOMEBREW_PREFIX}/opt/llvm/lib ${LDFLAGS}"
export CPPFLAGS="-I${HOMEBREW_PREFIX}/opt/llvm/include ${CPPFLAGS}"
# libc++
export LDFLAGS="-L${HOMEBREW_PREFIX}/opt/llvm/lib/c++ -Wl,-rpath,${HOMEBREW_PREFIX}/opt/llvm/lib/c++ ${LDFLAGS}"
# unwind
export LDFLAGS="-L${HOMEBREW_PREFIX}/opt/llvm/lib/unwind -lunwind ${LDFLAGS}"

# libomp
export LDFLAGS="-L${HOMEBREW_PREFIX}/opt/libomp/lib ${LDFLAGS}"
export CPPFLAGS="-I${HOMEBREW_PREFIX}/opt/libomp/include ${CPPFLAGS}"

# gcc
export LDFLAGS="-L${HOMEBREW_PREFIX}/opt/gcc/lib/gcc/12 ${LDFLAGS}"
export CPPFLAGS="-I${HOMEBREW_PREFIX}/opt/gcc/include/c++/12 ${CPPFLAGS}"

# ruby
export LDFLAGS="-L${HOMEBREW_PREFIX}/opt/ruby/lib ${LDFLAGS}"
export CPPFLAGS="-I${HOMEBREW_PREFIX}/opt/ruby/include ${CPPFLAGS}"
export PKG_CONFIG_PATH="${HOMEBREW_PREFIX}/opt/ruby/lib/pkgconfig:${PKG_CONFIG_PATH}"

# openjdk (Java)
export CPPFLAGS="-I${HOMEBREW_PREFIX}/opt/openjdk@11/include ${CPPFLAGS}"


################################################################################
# If exists, run the extra local startup script
################################################################################
if [[ -r "${SHELL_DIR_EXTRA_STARTUP_SCRIPTS}/.zshrc" ]]; then
  source "${SHELL_DIR_EXTRA_STARTUP_SCRIPTS}/.zshrc"
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
