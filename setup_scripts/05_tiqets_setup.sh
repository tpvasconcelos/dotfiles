#!/usr/bin/env bash

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Upgrade everything
brew update && brew upgrade


# Tiqets VPN
brew cask install tunnelblick


# Conda

# tiqds
#yes | conda create --name tiqds python=3.7
#conda activate tiqds
#pip install environment_kernels
#yes | conda install nb_conda nb_conda_kernels ipykernel
#python -m ipykernel install --user --name tiqds --display-name "Python 3.7 [conda env:tiqds]"
#
#yes | conda install -c conda-forge jupyter_contrib_nbextensions jupyter_nbextensions_configurator
#yes | conda install autopep8 yapf isort
#pip install blackcellmagic
#for e in code_font_size/code_font_size navigation-hotkeys/main nbextensions_configurator/config_menu/main code_prettify/code_prettify varInspector/main autosavetime/main collapsible_headings/main equation-numbering/main code_prettify/isort livemdpreview/livemdpreview python-markdown/main spellchecker/main codefolding/main comment-uncomment/main execute_time/ExecuteTime keyboard_shortcut_editor/main scratchpad/main code_prettify/autopep8 contrib_nbextensions_help_item/main freeze/main hinterland/hinterland nbextensions_configurator/tree_tab/main ruler/main snippets/main snippets_menu/main toc2/main hide_input_all/main
#do
#   jupyter nbextension enable $e --sys-prefix
#done
#
#
# Install jupytext
#yes | conda install -c conda-forge jupytext
#jupyter nbextension install --py jupytext
#jupyter nbextension enable --py jupytext


# Setup Tiqets Python env
virtualenv -p python2.7 envs/tiqetsapi
source ~/envs/tiqetsapi/bin/activate
cd ~/PycharmProjects/tiqetsweb/
pip install -r requirements-dev.txt
pip install -r requirements.txt
brew services start redis
pip install pre-commit
pre-commit install --install-hooks
pre-commit install -t pre-commit
pre-commit install -t pre-push
pre-commit install -t commit-msg


# Upgrade everything again, and cleanup!
brew update && brew upgrade && brew cleanup