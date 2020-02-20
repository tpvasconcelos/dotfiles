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
brew install python
brew install python3
pip3 install --upgrade pip
pip3 install bpython
brew install mypy
pip3 install black

# R
brew cask install r
brew cask install rstudio

# Anaconda and jupyter
yes n | jupyter notebook --generate-config
brew cask install anaconda
yes | conda update -n base -c defaults conda
yes | conda update --all
conda init zsh

# Get prophet working
# conda should install the appropriate requiremetns
#yes | conda install -c anaconda ephem
#yes | conda install -c anaconda gcc
#yes | conda install -c anaconda cython
#yes | conda install -c plotly plotly
#yes | conda install -c conda-forge pystan
yes | conda install -c conda-forge fbprophet

# Upgrade everything again, and cleanup!
brew update && brew upgrade && brew cleanup
