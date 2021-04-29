# debug:
# info:     ❱
# warn:     ✕
# error:    ✖
# success:  ✔

log_debug() {
  faint "[DEBUG] - ${*}" >&1
}

log_info() {
  bold "$(fg_cyan "[INFO] - ${*}")" >&1
}

log_warning() {
  bold "$(fg_yellow "[WARNING] - ${*}")" >&1
}

log_error() {
  bold "$(fg_red "[ERROR] - ${*}")" >&2
}

log_success() {
  bold "$(fg_green "[SUCCESS] - ${*}")" >&1
}
