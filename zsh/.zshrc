# Copy to home folder
# $ cp zsh/.zshrc ~/.zshrc  && source ~/.zshrc

# Load Nerd Fonts with Powerlevel9k theme for Zsh
# and Customise the Powerlevel9k prompts
POWERLEVEL9K_MODE='nerdfont-complete'
source ~/powerlevel9k/powerlevel9k.zsh-theme
ZSH_THEME="powerlevel9k/powerlevel9k"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(ssh dir vcs newline status)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

# Load Zsh tools for syntax highlighting and autosuggestions
HOMEBREW_FOLDER="/usr/local/share"
source "$HOMEBREW_FOLDER/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$HOMEBREW_FOLDER/zsh-autosuggestions/zsh-autosuggestions.zsh"
plugins=(zsh-autosuggestions)

# Color ls output
alias ls='ls -G -la'

# Fix PATH
export PATH=/bin:$PATH
# export PATH=/usr/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=~/anaconda3/bin:$PATH
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


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('~/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "~/anaconda3/etc/profile.d/conda.sh" ]; then
        . "~/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="~/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# git autocomplete
source ~/.zsh/_git/.git-prompt.sh
# source ~/.zsh/_git/.git-completion.zsh
fpath=(~/.zsh-completions/src $fpath)
fpath=(~/.zsh $fpath)
fpath=(~/.zsh/_git $fpath)


# ENV Variables
# ...

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# My aliasis
alias gotodsdir='cd $(find . -name "*$(git branch | grep \* | cut -d '-' -f2)*" -not -path "./.*" | head -n 1)'

# Misch
export LANG="en_US.UTF-8"
