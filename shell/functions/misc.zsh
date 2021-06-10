app-exists() {
  local app="${*}"
  if [[ "$(system_profiler -json SPApplicationsDataType | grep -i "\"${app}\"")" ]]; then
    true
  else
    log_warning "The app \"${app}\" does not exists!"
    false
  fi
}

restart() {
  # Restart a macOS app
  # Arguments:
  #   * $* : The app's full name
  # Examples:
  #   $ restart_app "Alfred 4"
  #   [INFO] - Killing "Alfred 4"
  #   [INFO] - Opening "Alfred 4"
  local app="${*}"
  app-exists "${app}" || return
  log_info "Killing \"${app}\""
  osascript -e "quit app \"${app}\"" &&
    log_info "Opening \"${app}\"" &&
    open -a "${app}"
}
