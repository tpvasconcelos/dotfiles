ansi() {
  local ansi_code msg
  ansi_code="${1}"
  msg="${*:2}"
  echo -e "\e[${ansi_code}m${msg}\e[0m"
}

# generic
bold()          { ansi 1 "$@"; }
faint()         { ansi 2 "$@"; }
italic()        { ansi 3 "$@"; }
underline()     { ansi 4 "$@"; }
#slow_blink()   { ansi 5 "$@"; }
#rapid_blink()  { ansi 6 "$@"; }
reverse()       { ansi 7 "$@"; }
#conceal()      { ansi 8 "$@"; }
strikethrough() { ansi 9 "$@"; }

# Set foreground color
fg_black()      { ansi 30 "$@"; }
fg_red()        { ansi 31 "$@"; }
fg_green()      { ansi 32 "$@"; }
fg_yellow()     { ansi 33 "$@"; }
fg_blue()       { ansi 34 "$@"; }
fg_magenta()    { ansi 35 "$@"; }
fg_cyan()       { ansi 36 "$@"; }
fg_white()      { ansi 37 "$@"; }

# Set background color
bg_black()      { ansi 40 "$@"; }
bg_red()        { ansi 41 "$@"; }
bg_green()      { ansi 42 "$@"; }
bg_yellow()     { ansi 43 "$@"; }
bg_blue()       { ansi 44 "$@"; }
bg_magenta()    { ansi 45 "$@"; }
bg_cyan()       { ansi 46 "$@"; }
bg_white()      { ansi 47 "$@"; }

# Set bright foreground color
bfg_black()     { ansi 90 "$@"; }
bfg_red()       { ansi 91 "$@"; }
bfg_green()     { ansi 92 "$@"; }
bfg_yellow()    { ansi 93 "$@"; }
bfg_blue()      { ansi 94 "$@"; }
bfg_magenta()   { ansi 95 "$@"; }
bfg_cyan()      { ansi 96 "$@"; }
bfg_white()     { ansi 97 "$@"; }

# Set bright background color
bbg_black()     { ansi 100 "$@"; }
bbg_red()       { ansi 101 "$@"; }
bbg_green()     { ansi 102 "$@"; }
bbg_yellow()    { ansi 103 "$@"; }
bbg_blue()      { ansi 104 "$@"; }
bbg_magenta()   { ansi 105 "$@"; }
bbg_cyan()      { ansi 106 "$@"; }
bbg_white()     { ansi 107 "$@"; }
