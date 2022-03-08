app-exists() {
  local app="${*}"
  if [[ "$(system_profiler -json SPApplicationsDataType | grep -i "\"${app}\"")" ]]; then
    true
  else
    log_warning "The app \"${app}\" does not exist!"
    false
  fi
}

restart() {
  # Restart a macOS app
  # Arguments:
  #   * $* : The app's full name
  # Examples:
  #   $ restart "Alfred 4"
  #   [INFO] - Killing "Alfred 4"
  #   [INFO] - Opening "Alfred 4"
  local app="${*}"
  app-exists "${app}" || return
  log_info "Killing \"${app}\""
  osascript -e "quit app \"${app}\"" &&
    log_info "Opening \"${app}\"" &&
    open -a "${app}"
}

manopt() {
  # SYNOPSIS
  #   manopt command opt
  #
  # DESCRIPTION
  #   Returns the portion of COMMAND's man page describing option OPT.
  #   Note: Result is plain text - formatting is lost.
  #
  #   OPT may be a short option (e.g., -F) or long option (e.g., --fixed-strings);
  #   specifying the preceding '-' or '--' is OPTIONAL - UNLESS with long option
  #   names preceded only by *1* '-', such as the actions for the `find` command.
  #
  #   Matching is exact by default; to turn on prefix matching for long options,
  #   quote the prefix and append '.*', e.g.: `manopt find '-exec.*'` finds
  #   both '-exec' and 'execdir'.
  #
  # EXAMPLES
  #   manopt ls l           # same as: manopt ls -l
  #   manopt sort reverse   # same as: manopt sort --reverse
  #   manopt find -print    # MUST prefix with '-' here.
  #   manopt find '-exec.*' # find options *starting* with '-exec'
  local cmd=$1 opt=$2
  [[ $opt == -* ]] || { ((${#opt} == 1)) && opt="-$opt" || opt="--$opt"; }
  man "$cmd" | col -b | awk -v opt="$opt" -v RS= '$0 ~ "(^|,)[[:blank:]]+" opt "([[:punct:][:space:]]|$)"'
}
