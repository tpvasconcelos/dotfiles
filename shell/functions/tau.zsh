# Utilities for managing multiple python versions on a single machine

_tau::source_tau_modules() {
  # shellcheck source=functions/_tau.zsh
  for tau_module in "$SHELL_DIR_FUNCTIONS/_tau"/*(.); do
    source "$tau_module"
  done
}

_tau::list_commands() {
  local -a fn_names cmd_names
  fn_names=(${(k)functions[(I)tau-*]})
  for fn_name in "${fn_names[@]}"; do
    cmd_names+=("${fn_name#tau-}")
  done
  if (( ${#cmd_names[@]} == 0 )); then
    return 0
  fi
  cmd_names=(${(u)cmd_names})
  cmd_names=(${(o)cmd_names})
  print -rl -- "${cmd_names[@]}"
}

_tau::print_help() {
  echo "Usage: tau <command> [args]"
  echo ""
  echo "Commands:"
  local cmd
  while IFS= read -r cmd; do
    echo "  ${cmd}"
  done < <(_tau::list_commands)
  echo ""
  echo "Run 'tau <command> --help' for command-specific usage."
}

tau() {
  local cmd fn_name
  cmd="${1:-}"
  if [[ -z "${cmd}" || "${cmd}" == "help" || "${cmd}" == "-h" || "${cmd}" == "--help" ]]; then
    _tau::print_help
    return 0
  fi
  shift
  fn_name="tau-${cmd}"
  if (( $+functions[$fn_name] )); then
    "${fn_name}" "$@"
    return $?
  fi

  log_error "Unknown tau command: ${cmd}"
  _tau::print_help
  return 1
}

_tau::source_tau_modules
