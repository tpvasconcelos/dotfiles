#!/usr/bin/env bash

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

# Upgrade everything
brew update && brew upgrade

# Data Science (python, anaconda, and stuff...)

# Python
brew install pyenv
pyenv install 2.7.18
pyenv install 3.7.8
pyenv install 3.8.5
#brew install python@3.7
#brew install python@3.8
pip3 install --upgrade pip

# R
brew cask install r
brew cask install rstudio

# Jupyter
yes n | jupyter notebook --generate-config

# Anaconda  ---
#brew cask install anaconda
#yes | conda update -n base -c defaults conda
#yes | conda update --all
#conda init zsh
#conda config --set auto_activate_base false
# Get prophet working
#yes | conda install -c conda-forge fbprophet

# misc
brew install graphviz
brew cask install jupyter-notebook-viewer


# Upgrade everything again, and cleanup!
brew update && brew upgrade && brew cleanup
