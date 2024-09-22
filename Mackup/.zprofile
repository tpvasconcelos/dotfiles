# shellcheck disable=SC1090,SC2034
#
# .zprofile startup script --> interactive shell settings
#
_ZPROFILE_LOADED=true

# Misc ---
eval "$(pyenv init --path)"

# Re-add the extra _ZSHENV_PATH_EXTRAS paths in the correct order.
# This is needed since the default /etc/zprofile startup script
# messes up with the order set in my ~/.zshenv script.
path=(
  "${_ZSHENV_PATH_EXTRAS[@]}"
  "${path[@]}"
)

################################################################################
# If exists, run the extra local startup script
################################################################################
if [[ -r "${SHELL_DIR_EXTRA_STARTUP_SCRIPTS}/.zprofile" ]]; then
  source "${SHELL_DIR_EXTRA_STARTUP_SCRIPTS}/.zprofile"
fi
