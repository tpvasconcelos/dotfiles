# =========================================================
# --- fzf - https://github.com/junegunn/fzf/wiki/examples
# =========================================================

# fh - repeat history
fh() {
  print -z "$(history | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')"
}

# autojump
fj() {
  local target
  if [[ "$#" -ne 0 ]]; then
    target="$(j "$@")"
  else
    target="$(j -s | sort -k1gr | awk '$1 ~ /[0-9]:/ && $2 ~ /^\// { for (i=2; i<=NF; i++) { print $(i) } }' | fzf --height 40% --reverse --inline-info)"
  fi
  cd "${target}" || return
}

# fkill - kill processes - list only the ones you can kill. Modified the earlier script.
fkill() {
  local pid
  if [ "${UID}" != "0" ]; then
    pid=$(ps -f -u "${UID}" | sed 1d | fzf -m | awk '{print $2}')
  else
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
  fi
  if [ "x${pid}" != "x" ]; then
    echo "${pid}" | xargs kill -"${1:-9}"
  fi
}

_get_branch() {
  git --no-pager branch \
    --sort=-committerdate \
    --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%(refname:short)%(end)%(end)" |
    sed '/^$/d' |
    fzf --no-multi -n 2 --ansi --preview="git --no-pager log -50 --pretty='format:%C(auto)%h [%ad] %s' --date=short '..{1}'"
}

# fdb - delete git branch
fdb() {
  _get_branch | xargs -I {} git branch -D {}
}

# fco - checkout git branch
fco() {
  _get_branch | xargs -I {} git checkout {}
}
