#!/usr/bin/env zsh

echo "🚀 Installing pyenv..."
brew install pyenv

source_if_exists "${DOTFILES}/shell/functions/interactive/python"
python_upgrade_all

echo "🚀 Installing pipenv..."
brew install pipenv

echo "🚀 Installing brew's python (and unlinking it!)..."
# TODO: is this step necessary? isnt python already installed? maybe simply unlink?
brew install python && brew unlink python

echo "🚀 Installing poetry..."
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python
poetry completions zsh > "$BREW_PREFIX/share/zsh/site-functions/_poetry"

echo "🚀 update, upgrade, and cleanup..."
brew update && brew upgrade && brew cleanup
