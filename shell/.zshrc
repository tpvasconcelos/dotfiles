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
# fpath=(~/.zsh/_git $fpath)

fpath=(~/.zsh-completions/src $fpath)
fpath=(~/.zsh $fpath)

# Fix PATH
export PATH=/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/anaconda3/bin:$PATH
export PATH=/usr/local/mysql/bin:$PATH
export PATH=/Library/TeX/texbin:$PATH
export PATH=~/mongodb/bin:$PATH
export PATH=/usr/local/opt/llvm/bin:$PATH

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/usr/local/anaconda3/bin/conda' 'shell.zsh' 'hook' 2>/dev/null)"
if [ $? -eq 0 ]; then
  eval "$__conda_setup"
else
  if [ -f "/usr/local/anaconda3/etc/profile.d/conda.sh" ]; then
    . "/usr/local/anaconda3/etc/profile.d/conda.sh"
  else
    export PATH="/usr/local/anaconda3/bin:$PATH"
  fi
fi
unset __conda_setup
# <<< conda initialize <<<

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
export PATH="/usr/local/opt/node@10/bin:$PATH"
export CPPFLAGS="-I/usr/local/opt/llvm/include"export
LDFLAGS="-L/usr/local/opt/llvm/lib"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
