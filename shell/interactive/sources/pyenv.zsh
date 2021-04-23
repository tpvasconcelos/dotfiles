########################################
# pyenv
########################################
PYENV_ROOT=$(pyenv root)
export PYENV_ROOT
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
