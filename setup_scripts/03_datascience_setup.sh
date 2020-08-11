#!/usr/bin/env bash


# ============================================================
#
# Data Science
# * Python
#     * pyenv
#     * pipenv
#     * python for brew
#     * Jupyter
#     * Anaconda
# * R
# * Misc
#
# ============================================================



# Setup script and permissions =========================== >>>
# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &
# ======================================================== <<<



# Upgrade everything ===================================== >>>
brew update && brew upgrade
# ======================================================== <<<



# Python ================================================= >>>

# pyenv  ---
brew install pyenv
SDKROOT=/Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk MACOSX_DEPOLOYMENT_TARGET=10.15 \
    pyenv install 2.7.18 && \
    pyenv install 3.7.8  && \
    pyenv install 3.8.5
pyenv global 3.8.5 && eval "$(pyenv init -)"

# pipenv  ---
brew install pipenv

# python for brew  ---
brew install python && brew unlink python

# Jupyter  ---
yes n | jupyter notebook --generate-config
brew cask install jupyter-notebook-viewer

# Anaconda  ---
#brew cask install anaconda
#yes | conda update -n base -c defaults conda
#yes | conda update --all
#conda init zsh
#conda config --set auto_activate_base false
# Get prophet working
#yes | conda install -c conda-forge fbprophet

# ======================================================== <<<


# R ====================================================== >>>
brew cask install r
brew cask install rstudio
# ======================================================== <<<


# Misc =================================================== >>>
brew install graphviz
# ======================================================== <<<


# Upgrade everything again, and cleanup ================== >>>
brew update && brew upgrade && brew cleanup
# ======================================================== <<<
