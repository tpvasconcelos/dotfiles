#!/usr/bin/env bash

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Install brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Upgrade everything
brew update && brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed
# Install Bash 4.
brew install bash
brew install bash-completion2

# Switch to using brew-installed bash as default shell
if ! fgrep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
  echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells;
  chsh -s "${BREW_PREFIX}/bin/bash";
fi;

# Set up a terminal (iTerm2 + zsh + oh-my-zsh)
brew cask install iterm2
killall cfprefsd
cp shell/com.googlecode.iterm2.plist ~/Library/Preferences
brew install zsh
# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
# Powerlevel9k
brew tap sambadevi/powerlevel9k
brew install powerlevel9k
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
brew install zsh-autosuggestions
brew install zsh-syntax-highlighting
# Change the default shell to zsh
chsh -s /bin/zsh


# Data Science (python, anaconda, and stuff...)

# Python
brew install python
brew install python3
sudo pip install bpython
brew install mypy
pip install black

# R
brew cask install r
brew cask install rstudio

# Anaconda and jupyter
yes n | jupyter notebook --generate-config
brew cask install anaconda
yes | conda update -n base -c defaults conda
conda init zsh

yes | conda create --name tiqds python=3.6
conda activate tiqds
pip install environment_kernels
yes | conda install nb_conda nb_conda_kernels ipykernel
python -m ipykernel install --user --name tiqds --display-name "Python 3.6 [conda env:tiqds]"

yes | conda install -c conda-forge jupyter_contrib_nbextensions jupyter_nbextensions_configurator
yes | conda install autopep8 yapf isort
pip install blackcellmagic
for e in code_font_size/code_font_size navigation-hotkeys/main nbextensions_configurator/config_menu/main code_prettify/code_prettify varInspector/main autosavetime/main collapsible_headings/main equation-numbering/main code_prettify/isort livemdpreview/livemdpreview python-markdown/main spellchecker/main codefolding/main comment-uncomment/main execute_time/ExecuteTime keyboard_shortcut_editor/main scratchpad/main code_prettify/autopep8 contrib_nbextensions_help_item/main freeze/main hinterland/hinterland nbextensions_configurator/tree_tab/main ruler/main snippets/main snippets_menu/main toc2/main hide_input_all/main
do
   jupyter nbextension enable $e --sys-prefix
done

# Install jupytext
yes | conda install -c conda-forge jupytext
jupyter nbextension install --py jupytext
jupyter nbextension enable --py jupytext


# Install more recent versions of some macOS tools.
brew install vim
brew install grep
brew install openssh
brew install screen
brew install php
brew install gmp

# Install font tools.
brew tap bramstein/webfonttools
brew install sfnt2woff
brew install sfnt2woff-zopfli
brew install woff2
brew tap caskroom/fonts
brew cask install font-hack-nerd-font

# Useful command line tools
brew install wget
brew install tree
brew install rename
brew install htop
brew install git
brew install git-lfs
brew install hub
brew install mdv
brew install howdoi

# Misc tools
brew install zlib
brew install sqlite
brew install postgresql && sudo pip install psycopg2
brew install freetype
brew install libxslt
brew install libpq
brew install node@10
brew install yarn && yarn && yarn build
brew install redis
npm install -g lookml-parser
pip install lookml-tools

# -- Install some Apps

# Text editors/IDEs
brew cask install textmate
brew cask install sublime-text
brew cask install brackets
brew cask install atom
brew cask install visual-studio-code
brew cask install texpad
mas install 497799835 # Xcode
mas install 1225570693 # Ulysses
# JetBrains
brew cask install pycharm
brew cask install datagrip
brew cask install webstorm

# Docker
brew cask install docker
brew cask install kitematic

# Misc Devs
brew cask install virtualbox
#brew install awscli
#brew cask install postman
#brew cask install paw

# Browsers
brew cask install google-chrome
brew cask install tor-browser
brew cask install firefox

# Productivity & Office
brew cask install alfred
brew cask install skitch
brew cask install microsoft-office
brew cask install skype
brew cask install the-unarchiver
brew cask install whatsapp
brew cask install slack

# Misc
brew cask install vuze
brew cask install spotify
brew cask install vlc
brew cask install adobe-creative-cloud
brew cask install blender
brew cask install appcleaner
brew cask install omnidisksweeper
brew cask install muzzle
mas install 909566003 # iHex
mas install 909760813 # Who's On My WiFi


# Manual install:
# - Popcorn-Time
# - Streamio
# - Photoshop
# - Lightroom
# - Affinity Photo
# - Affinity Designer
# - File Viewer
# -

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

# Tiqets VPN
brew cask install tunnelblick


# Upgrade everything again, and cleanup!
brew update && brew upgrade && brew cleanup