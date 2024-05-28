git-multi-summary() {
  # Recursively search for all git repos in the current directory and
  # print a summary of their status.
  #
  # Usage:
  #   git-multi-summary [OPTIONS]
  #
  # Options:
  #   --abspath               Print absolute paths instead of relative paths
  #   --fetch                 Fetch from all remotes
  #   --lfs-fetch             Use Git LFS to fetch and pull
  #   --push-ahead            Try to run `git push` for repos ahead of remote
  #   --force-push-archived   For archived repos: unarchive, push, re-archive
  #   --log-ok                Log repos with no issues
  #
  # Alternatives:
  #   https://myrepos.branchable.com/
  #   https://github.com/x-motemen/ghq
  #   https://github.com/nosarthur/gita
  #   https://github.com/fboender/multi-git-status
  #   https://github.com/alajmo/mani
  #   https://github.com/nickgerace/gfold
  #   https://github.com/tkrajina/git-plus
  #   https://github.com/orf/git-workspace
  #   https://github.com/landonb/ohmyrepos
  #
  all_repos=$(find . -maxdepth 6 -type d -name .git -exec dirname {} \;)
  for repo in $(echo "${all_repos}"); do
    if [[ "$*" == *--log-ok* ]]; then
      do_log=true
    else
      do_log=false
    fi

    if [[ "$*" == *--abspath* ]]; then
      log_str="$(abspath "${repo}")"
    else
      log_str="${repo}"
    fi

    if [[ -z $(git -C "${repo}" remote) ]]; then
      do_log=true
      log_str="${log_str} $(bold $(fg_red "[no remote]"))"
    else
      if [[ "$*" == *--fetch* ]]; then
        git -C "${repo}" fetch --all --tags --prune --quiet
        if [[ "$*" == *--lfs* ]]; then
          git -C "${repo}" lfs fetch --all --prune
        fi
      fi
      if [[ -n $(git -C "${repo}" status --porcelain) ]]; then
        do_log=true
        log_str="${log_str} $(bold $(fg_yellow "[dirty]"))"
      else
        if [[ -n $(git -C "${repo}" status --porcelain --branch | grep -E "ahead") ]]; then
          do_log=true
          log_str="${log_str} $(bold $(fg_cyan "[ahead]"))"
          git -C "${repo}" pull --quiet
          if [[ "$*" == *--lfs* ]]; then
            git -C "${repo}" lfs pull
          fi
          if [[ "$*" == *--push-ahead* ]]; then
            if [[ "$*" == *--force-push-archived* ]]; then
              origin_url="$(git -C "${repo}" remote get-url origin)"
              unarchive_result="$(gh repo unarchive "${origin_url}" --yes)"
              git -C "${repo}" push --all
              if [[ "$unarchive_result" != *"is not archived"* ]]; then
                gh repo archive "${origin_url}" --yes
              fi
            else
              git -C "${repo}" push --all
            fi
          fi
        fi
      fi
    fi

    if [[ "$*" == *--mirror-push* ]]; then
      mirror_url="..."
      git -C "${repo}" remote add --mirror=fetch mirror "${mirror_url}"
      git -C "${repo}" push --set-upstream mirror
      git -C "${repo}" fetch --all --tags --prune --quiet
      git -C "${repo}" remote prune origin
      git -C "${repo}" remote prune mirror
      git -C "${repo}" push origin --all --quiet
      git -C "${repo}" push origin --tags --quiet
      git -C "${repo}" push mirror --all --quiet
      git -C "${repo}" push mirror --tags --quiet
    fi

    if [[ "$do_log" == true ]]; then
      if [[ "${log_str}" == *\[* ]]; then
        echo "${log_str}"
      else
        echo "$(faint "${log_str}") $(bold $(fg_green "[ok]"))"
      fi
    fi
  done
}
