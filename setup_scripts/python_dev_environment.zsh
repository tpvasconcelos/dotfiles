#!/usr/bin/env zsh
set -eu

log_info "Installing pyenv..."
brew install pyenv

load "${SHELL_DIR_INTERACTIVE}/functions/string"
load "${SHELL_DIR_INTERACTIVE}/functions/tau"
tau_install_all
# FIXME: tau_install_all && tau_cleanup

log_info "Installing pipenv..."
brew install pipenv

log_info "Installing brew's python (and unlinking it!)..."
# TODO: is this step necessary? isnt python already installed? maybe simply unlink?
brew install python && brew unlink python

log_info "Installing poetry..."
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python
poetry completions zsh > "$BREW_PREFIX/share/zsh/site-functions/_poetry"

log_info "update, upgrade, and cleanup..."
brew update && brew upgrade && brew cleanup
