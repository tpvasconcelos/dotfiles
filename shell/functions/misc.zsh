cmd_exists() {
  # Check if a command exists
  #
  # Returns 0 exit code if the command exists and 1 otherwise
  #
  # Usage
  #   cmd_exists <command>
  #
  # Arguments
  #   $1  command to check
  #
  # Examples
  #   $ cmd_exists git; echo $?
  #   0
  #   $ cmd_exists foo; echo $?
  #   1
  local cmd="$1"
  command -v "$cmd" >/dev/null 2>&1
}

app_exists() {
  # Check if an app exists
  #
  # Returns 0 exit code if the app exists and 1 otherwise
  #
  # Usage
  #   app_exists <app>
  #
  # Arguments
  #   $1  app name
  #
  # Examples
  #   $ app_exists Finder; echo $?
  #   0
  #   $ app_exists FooBar; echo $?
  #   1
  local app="${*}"
  if system_profiler -json SPApplicationsDataType | grep -iq "\"$app\""; then
    return 0
  else
    return 1
  fi
}

need_cmd() {
  # Check if a command exists.
  #
  # If the command does not exist, print an error message and exit
  # with an exit code of 1.
  #
  # Usage
  #   need_cmd <command>
  #
  # Arguments
  #   $1  command to check
  #
  # Examples
  #   $ need_cmd git; echo $?
  #   0
  #   $ need_cmd foo; echo $?
  #   [✘] Command 'foo' not found!
  #   1
  local cmd="$1"
  if ! cmd_exists "$cmd"; then
    log_error "Command '$cmd' not found!"
    return 1
  fi
}

ask-yesno() {
  # Ask a yes/no question
  #
  # Usage
  #   ask-yesno <question>
  #
  # Arguments
  #   $1  question to ask
  #
  # Examples
  #   $ ask-yesno "Do you want to continue?"
  #   Do you want to continue? [y/n]
  #   $ echo $?
  #   1
  local question="${*}"
  echo -n "$question [y/n] "
  while true; do
    read -r -k 1 yn
    echo
    case $yn in
    [Yy]*)
      return 0 ;;
    [Nn]*)
      return 1 ;;
    *)
      echo -n "$(fg_red "$(bold "Option not recognised!")") "
      echo -n "Please type $(bold "y/Y") for yes or $(bold "n/N") for no... [y/n] "
      ;;
    esac
  done
}

restart() {
  # Restart a macOS app
  #
  # Arguments
  #   $*  The app's full name
  #
  # Examples
  #   $ restart Alfred 4
  #   [ℹ] Killing "Alfred 4"
  #   [ℹ] Opening "Alfred 4"
  #   $ restart FooBar
  #   [⚠] The app "FooBar" does not exist!
  local app="${*}"
  if ! app_exists "$app"; then
    log_warning "The app \"${app}\" does not exist!"
  fi
  log_info "Killing \"$app\""
  osascript -e "quit app \"$app\"" &&
    log_info "Opening \"$app\"" &&
    open -a "$app"
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
