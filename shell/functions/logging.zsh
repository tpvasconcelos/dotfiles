log_debug() {
  faint "[⋯] ${*}" >&1
}

log_info() {
  bold "$(fg_cyan "[ℹ] ${*}")" >&1
}

log_success() {
  bold "$(fg_green "[✔] ${*}")" >&1
}

log_warning() {
  bold "$(fg_yellow "[⚠] ${*}")" >&1
}

log_error() {
  bold "$(fg_red "[✘] ${*}")" >&2
}

# Alternative symbols:
#
# debug:    ➤ or ➣ or 🔧 or ➔ or ➣ or 🐛
# info:     ▶ or ❱ or 👉 or ➔ or ➜ or ⮕ or 🞧
# success:  ✔ or ✓ or ✅
# warning:  ⚠ or ✕ or ❗
# error:    ✖ or ✘ or ❌ or ℯ
#
# Test it out:
#
# log_debug "This is a debug message"
# log_info "This is an info message"
# log_success "This is a success message"
# log_warning "This is a warning message"
# log_error "This is an error message"
