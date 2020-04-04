# Copy to home folder
# $ cp shell/.bashrc ~/.bashrc && source ~/.bashrc

# Create alias for Blender
alias blender=/Applications/blender_latest/blender.app/Contents/MacOS/blender

# export MySQL path
PATH="/usr/local/mysql/bin:${PATH}"
export PATH

# Setting PATH for ruby 2.5.0
PATH="~/.gem/ruby/2.5.0/bin:${PATH}"
export PATH

# Setting PATH for Python 2.7
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
export PATH

# Setting PATH for Python 3.7
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"
export PATH

export PATH="/usr/local/sbin:$PATH"

# added by Anaconda3 2018.12 installer
# >>> conda init >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$(CONDA_REPORT_ERRORS=false '~/anaconda3/bin/conda' shell.bash hook 2> /dev/null)"
if [[ $? -eq 0 ]]; then
    \eval "$__conda_setup"
else
    if [[ -f "~/anaconda3/etc/profile.d/conda.sh" ]]; then
        . "~/anaconda3/etc/profile.d/conda.sh"
        CONDA_CHANGEPS1=false conda activate base
    else
        \export PATH="~/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda init <<<

# Use the sed installed with brew instead of the the system's sed
export PATH=$(brew --prefix gnu-sed)/libexec/gnubin:$PATH

export PATH=~/mongodb/bin:$PATH

# X13 ARIMA-SEATS
export PATH="$HOME/x13as/bin/:$PATH"
export X13PATH="$HOME/x13as/bin/"