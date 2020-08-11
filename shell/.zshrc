# Copy to home folder
# $ cp shell/.zshrc ~/.zshrc  && source ~/.zshrc

# Load Nerd Fonts with Powerlevel9k theme for Zsh
# and Customise the Powerlevel9k prompts
ZSH_THEME="powerlevel9k/powerlevel9k"
POWERLEVEL9K_MODE='nerdfont-complete'
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(virtualenv anaconda pyenv dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
POWERLEVEL9K_TIME_FORMAT="%D{%H:%M}"

POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND='yellow'
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND='yellow'
POWERLEVEL9K_DIR_HOME_BACKGROUND='yellow'
POWERLEVEL9K_DIR_ETC_BACKGROUND='yellow'

HOMEBREW_FOLDER="/usr/local/share"
source ~/.oh-my-zsh/custom/themes/powerlevel9k/powerlevel9k.zsh-theme
source "$HOMEBREW_FOLDER/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOMEBREW_FOLDER/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

ZSH_DISABLE_COMPFIX=true

ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

plugins=(
  git
  iterm2
  docker
  man
  osx
  python
  composer
  zsh-syntax-highlighting
  zsh-autosuggestions
)

# git autocomplete
# source ~/.zsh/_git/.git-prompt.sh
# source ~/.zsh/_git/.git-completion.zsh
# fpath=(~/.zsh/_git $fpath)Deploying to namespace: ci

fpath=(~/.zsh-completions/src $fpath)
fpath=(~/.zsh $fpath)

# Fix PATH
export PATH="/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/mysql/bin:$PATH"
export PATH="/Library/TeX/texbin:$PATH"
export PATH="$HOME/mongodb/bin:$PATH"
export PATH="$HOME/.gem/ruby/2.7.0/bin:$PATH"
export PATH="$HOME/dev/flutter/bin:$PATH"
export PATH="$(brew --prefix llvm)/bin:$PATH"
export PATH="$(brew --prefix ruby)/bin:$PATH"
export PATH="$(brew --prefix openssl)/bin:$PATH"
export PATH="$(brew --prefix sqlite)/bin:$PATH"
export PATH="$(brew --prefix node)/bin:$PATH"
#export PATH="/usr/local/opt/python3/bin:$PATH"
#export PATH="/usr/local/opt/python@3.7/bin:$PATH"
#export PATH="/usr/local/opt/python@3.8/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"

# X13 ARIMA-SEATS
export PATH="$HOME/x13as/bin/:$PATH"
export X13PATH="$HOME/x13as/bin/"

# Ruby
export PATH="/usr/local/opt/ruby/bin:$PATH"
eval "$(rbenv init -)"

# Golang
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

# pyenv
export PYENV_ROOT=$(pyenv root)
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi


##############################################################################
# History Configuration
##############################################################################
HISTSIZE=10000                  # How many lines of history to keep in memory
SAVEHIST=50000                  # Number of history entries to save to disk
HISTFILE="$HOME/.zsh_history"   # Where to save history to disk
HISTDUP=erase                   # Erase duplicates in the history file
setopt appendhistory            # Append history to the history file (no overwriting)
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
setopt HIST_BEEP                # Beep when accessing nonexistent history.



# ENV Variables
# ...

# My aliasis
alias ls='ls -G -la'
alias gotodsdir='cd $(find . -name "*$(git branch | grep \* | cut -d '-' -f2)*" -not -path "./.*" | head -n 1)'

function py2nb() {
  jupytext --to notebook $1
  jupytext --sync $1
}

function nb2py() {
  jupytext --to py:percent $1
  jupytext --sync $1
}

function login-ec2() {
  AWS_PROFILE=data-eng aws ssm start-session --target i-"$1"
}

# Misch
export LANG="en_US.UTF-8"
export TIQETS_ENV="tomas"

# CPP and LDF Flags and PKG_CONFIG_PATH
# # openssl
# export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
# export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
# export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig"
# # readline
# export LDFLAGS="-L/usr/local/opt/readline/lib"
# export CPPFLAGS="-I/usr/local/opt/readline/include"
# export PKG_CONFIG_PATH="/usr/local/opt/readline/lib/pkgconfig"
# # sqlite
# export LDFLAGS="-L/usr/local/opt/sqlite/lib"
# export CPPFLAGS="-I/usr/local/opt/sqlite/include"
# export PKG_CONFIG_PATH="/usr/local/opt/sqlite/lib/pkgconfig"
# # llvm
# export LDFLAGS="-L/usr/local/opt/llvm/lib"
# export CPPFLAGS="-I/usr/local/opt/llvm/include"
# # zlib
# export LDFLAGS="-L/usr/local/opt/llvm/lib -Wl,-rpath,/usr/local/opt/llvm/lib"
# export LDFLAGS="-L/usr/local/opt/zlib/lib"
# export CPPFLAGS="-I/usr/local/opt/zlib/include"
# export PKG_CONFIG_PATH="/usr/local/opt/zlib/lib/pkgconfig"
# # MERGED
export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib -L/usr/local/opt/readline/lib -L/usr/local/opt/sqlite/lib -L/usr/local/opt/llvm/lib -L/usr/local/opt/zlib/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include -I/usr/local/opt/readline/include -I/usr/local/opt/sqlite/include -I/usr/local/opt/llvm/include -I/usr/local/opt/zlib/include"
export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig:/usr/local/opt/readline/lib/pkgconfig:/usr/local/opt/sqlite/lib/pkgconfig:/usr/local/opt/zlib/lib/pkgconfig"


test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
