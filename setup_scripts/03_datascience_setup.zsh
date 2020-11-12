#!/usr/bin/env zsh


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
LATEST_PY27="$(pyenv install --list | grep "^  2.7" | tail -n 1)"
LATEST_PY37="$(pyenv install --list | grep "^  3.7" | tail -n 1)"
LATEST_PY38="$(pyenv install --list | grep "^  3.8" | tail -n 1)"
# LATEST_PY39="$(pyenv install --list | grep "^  3.9" | tail -n 1)"
SDKROOT=/Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk MACOSX_DEPOLOYMENT_TARGET=10.15 \
    pyenv install "$LATEST_PY27" \
    pyenv install "$LATEST_PY37" \
    pyenv install "$LATEST_PY38"
    # pyenv install "$LATEST_PY39"
pyenv global "$LATEST_PY38" && eval "$(pyenv init -)"

# pipenv  ---
brew install pipenv

# python for brew  ---
brew install python && brew unlink python

# python-poetry
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python
poetry completions zsh > /usr/local/share/zsh/site-functions/_poetry

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
