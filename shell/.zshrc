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
# export PATH=/usr/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/anaconda3/bin:$PATH
export PATH=/usr/local/mysql/bin:$PATH
export PATH=/Library/TeX/texbin:$PATH
# export PATH=:$PATH
# export PATH=:$PATH
# /sbin
# /usr/sbin
# /usr/local/sbin
# /opt/X11/bin
# ~/.gem/ruby/2.5.0/bin
# /Library/Frameworks/Python.framework/Versions/3.7/bin
# /Library/Frameworks/Python.framework/Versions/2.7/bin
# /Library/Frameworks/Python.framework/Versions/3.7/bin
# /Library/Frameworks/Python.framework/Versions/3.6/bin
# /Library/Frameworks/Python.framework/Versions/2.7/bin

export PATH=~/mongodb/bin:$PATH

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/usr/local/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
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


# Misch
export LANG="en_US.UTF-8"
export TIQETS_ENV="tomas"
export PATH="/usr/local/opt/node@10/bin:$PATH"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

