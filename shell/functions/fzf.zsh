# =========================================================
# --- fzf - https://github.com/junegunn/fzf/wiki/examples
# =========================================================


# fh - repeat history
fh() {
  print -z "$( history | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')"
}


# fkill - kill processes - list only the ones you can kill. Modified the earlier script.
fkill() {
    local pid
    if [ "${UID}" != "0" ]; then
        pid=$(ps -f -u "${UID}" | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi
    if [ "x${pid}" != "x" ]
    then
        echo "${pid}" | xargs kill -"${1:-9}"
    fi
}


# fbr - checkout git branch (including remote branches), sorted by most recent commit, limit 30 last branches
fbr() {
  local branches branch
  branches=$(git for-each-ref --no-merged master --count=30 --sort=-committerdate --format='%(committerdate:relative),%(authorname),%(refname:short),%(if)%(upstream)%(then)%(upstream)%(end)' refs/heads |
             column -t -s ',' | grep -v "$(git branch --show-current)") &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout "$(echo "$branch" | sed "s/.* //" | sed "s#origin/*/##")"
  # sed "s#remotes/[^/]i*/##"
}
