_hc::check_expired_gpg_keys() {
  # Check for expired gpg keys
  yellow-bold() {
    fg_yellow "$(bold "$*")"
  }
  if gpg --list-keys | grep -q expired; then
    log_warning "Found expired GPG keys!"
    echo "Steps to update them:"
    echo "1. Run $(yellow-bold 'gpg --list-keys --with-subkey-fingerprints') to check the fingerprints of the expired keys."
    echo "2. Run $(yellow-bold 'gpg --quick-set-expire FINGERPRINT EXPIRE [SUBKEY-FPRS]') to update them."
    echo "For instance, to update the 'ABC123' key and its DEF456 subkey to expire in 1 year, run:"
    yellow-bold "$ gpg --quick-set-expire 'ABCD1234' '1y' 'DEF456'"
  else
    log_success "No expired GPG keys found!"
  fi
}

_hc::check_dotfiles() {
  # Check DOTFILES_DIR is set
  if [[ -z "$DOTFILES_DIR" ]]; then
    log_error "The DOTFILES_DIR environment variable is not set!"
    echo "The default location should be ~/.dotfiles."
    echo "Please refer to https://github.com/tpvasconcelos/dotfiles for more information."
    return 1
  fi

  # https://github.com/AGWA/git-crypt/issues/69#issuecomment-1129962604
  if git -C "$DOTFILES_DIR" config --local --get filter.git-crypt.smudge | grep -q 'smudge'; then
    log_success "The dotfiles repository is unlocked!"
  else
    log_error "The dotfiles repository is locked with git-crypt!"
    echo "Please unlock it by running $(bold 'git-crypt unlock') or refer to"
    echo "https://github.com/tpvasconcelos/dotfiles#unlocking-this-repository for more information."
  fi
}

hc-doctor() {
  if [[ "$*" == *--help* ]]; then
    echo "Usage: hc-doctor [OPTIONS]"
    echo ""
    echo "Options:"
    echo "    --skip-dot-backup     Skip backing up dotfiles"
    echo "    --skip-system         Skip checking for system software updates"
    echo "    --skip-brewfile       Skip Brewfile checks"
    echo "    --skip-brew-doctor    Skip running brew doctor"
    echo "    --help                Show this help message and exit"
    return 0
  fi

  if [[ "$*" != *--skip-dot-backup* ]]; then
    dot-backup
  fi

  if [[ "$*" != *--skip-system* ]]; then
    log_info "Checking for system software updates..."
    softwareupdate_output=$(softwareupdate --list --all)
    if [[ "$softwareupdate_output" == *"found the following new or updated software"* ]]; then
      log_warning "Found available software updates:"
      softwareupdate_filtered="$(echo "$softwareupdate_output" | awk 'NR > 4')"
      fg_yellow "$softwareupdate_filtered"
    else
      log_success "System software is up-to-date!"
    fi
  fi

  _hc::check_dotfiles
  _hc::check_expired_gpg_keys

  if [[ "$*" != *--skip-brewfile* ]]; then
    brew_bundle_cleanup_output=$(brew bundle cleanup --global 2>&1)
    brew_bundle_cleanup_output="${brew_bundle_cleanup_output//brew bundle cleanup/brew bundle cleanup --global}"
    if [[ $? -ne 0 ]]; then
      log_error "Error running brew bundle cleanup:"
      echo "$brew_bundle_cleanup_output"
    elif [[ -n "$brew_bundle_cleanup_output" ]]; then
      log_warning "Found installed packages not listed in the global Brewfile! You may want to update it."
      echo "$brew_bundle_cleanup_output"
    else
      log_success "All installed packages are listed in the global Brewfile!"
    fi
  fi

  brew_outdated_output=$(brew outdated --verbose)
  if [[ -n "$brew_outdated_output" ]]; then
    log_warning "Found outdated brew packages:"
    fg_yellow "$brew_outdated_output"
  else
    log_success "Brew packages are up-to-date!"
  fi

  if [[ "$*" != *--skip-brew-doctor* ]]; then
    log_info "Running brew doctor..."
    brew doctor
  fi
}

hc-update-everything() {
  if [[ "$*" == *--help* ]]; then
    echo "Usage: hc-update-everything [OPTIONS]"
    echo ""
    echo "Options:"
    echo "    --system              Run a system software update first"
    echo "    --brew-greedy-latest  Also update brew casks with a :latest version tag"
    echo "    --flutter             Also update Flutter and Dart"
    echo "    --help                Show this help message and exit"
    return 0
  fi

  # Update oh-my-zsh
  if [[ -n "$ZSH" ]]; then
    zsh "$ZSH/tools/upgrade.sh" -v minimal
  else
    log_warning "Skipping omz update. ZSH is not available which means that you're probably running in non-interactive mode."
  fi

  # Update brew packages
  brew update
  brew bundle --global
  brew upgrade
  if [[ "$*" == *--brew-greedy-latest* ]]; then
    # Also update brew casks with a :latest version tag
    brew upgrade --greedy-latest
  fi

  # Update all uv tools
  uv tool upgrade --all

  # Update rust
  rustup update

  # Update Flutter and Dart
  if [[ "$*" == *--flutter* ]]; then
    flutter upgrade
  fi

  # Upgrade all `gh` CLI extensions
  gh extension upgrade --all

  # Update npm
  # NOTE: no sudo here - Homebrew's global prefix is user-owned, and running
  # npm as root plants root-owned files in ~/.npm that break `npm cache clean`
  npm install npm --global --no-fund
  npm update --global --no-fund

  # Update yarn
  yarn global upgrade

  # Update Ruby gems
  sudo gem update --system

  # Check for expired gpg keys
  _hc::check_expired_gpg_keys

  # Backup dotfiles
  dot-backup

  # System software update
  if [[ "$*" == *--system* ]]; then
    sudo softwareupdate --install --all --verbose --force --agree-to-license
  fi

  log_success "Done! 🚀"

  # Restart the shell
  exec zsh
}

hc-reclaim-diskspace() {
  if [[ "$*" == *--help* ]]; then
    echo "Usage: hc-reclaim-diskspace [OPTIONS]"
    echo ""
    echo "Reclaim disk space from developer caches. By default, this:"
    echo "  - clears the homebrew, pipenv/pip, npm, yarn, Ruby gem, and pre-commit caches"
    echo "  - prunes the pnpm store and uv cache"
    echo "  - garbage-collects the Nix store"
    echo "  - clears the DotSlash binary cache (tools re-download on first use)"
    echo "  - removes leaked Codex marketplace staging dirs (>2 days old)"
    echo "  - removes Bazel output bases whose workspace no longer exists"
    echo "  - prunes Bazel repository-cache downloads unused for 90+ days (skipped while"
    echo "    a Bazel server is running)"
    echo "  - prunes docker's unused data incl. volumes (if docker is running)"
    echo "  - deletes unavailable iOS Simulators"
    echo ""
    echo "Options:"
    echo "    --bazel           Also wipe Bazel build caches (skipped while a Bazel server"
    echo "                      is running; 'bazel shutdown' in each workspace first)"
    echo "    --bazel-clean-canva"
    echo "                      Also 'bazel clean' the canva monorepo checkout, dropping its"
    echo "                      build outputs (~18GB) but keeping fetched external repos;"
    echo "                      fails fast if another Bazel command is running there"
    echo "    --canva-git       Also cruft-repack the canva monorepo's .git, expiring"
    echo "                      unreachable objects older than 30 days (takes ~30 min)"
    echo "    --uv-clean        Fully wipe the uv cache instead of pruning it"
    echo "    --skip-uv         Skip clearing/pruning uv caches"
    echo "    --skip-nix-store  Skip clearing Nix store"
    echo "    --help            Show this help message and exit"
    return 0
  fi

  log_info "Clearing homebrew's caches..."
  brew cleanup --scrub

  log_info "Clearing pipenv, pip, and pip-tools caches..."
  pipenv --clear

  log_info "Clearing npm caches..."
  npm cache clean --force

  log_info "Clearing yarn caches..."
  yarn cache clean

  log_info "Clearing pnpm caches..."
  pnpm store prune

  log_info "Clearing Ruby gems caches..."
  sudo gem cleanup

  # NOTE: long-lived `uv run`/`uvx` processes (MCP servers, background apps) hold a
  # shared lock on the cache for their entire lifetime, so on this machine the lock is
  # effectively never free and an un-forced clean/prune would wait forever. --force
  # skips the in-use check. Project venvs are unaffected (hardlinks outside the cache),
  # but ephemeral `uvx` tool environments live *inside* the cache, so a full wipe can
  # break running uvx tools (e.g. MCP servers) - restart them if they misbehave.
  local uv_live_procs
  if [[ "$*" == *--skip-uv* ]]; then
    log_info "Skipping uv caches clearing..."
  elif [[ "$*" == *--uv-clean* ]]; then
    log_info "Fully wiping uv cache..."
    # Only `uvx` tools are at risk from a wipe (their ephemeral envs live inside the
    # cache); `uv run` project venvs live outside it and are unaffected.
    uv_live_procs=$(ps -axo command | grep -E '^[^ ]*/uvx |^[^ ]*/uv tool uvx ' | awk '{print $NF}' | sort -u | tr '\n' ' ')
    if [[ -n "$uv_live_procs" ]]; then
      log_warning "Live uvx tools have their environments inside this cache - restart them if they misbehave: $uv_live_procs"
    fi
    uv cache clean --force
  else
    log_info "Pruning uv cache (pass --uv-clean for a full wipe)..."
    uv cache prune --force
  fi

  # pre-commit is not installed globally (only per-repo), so remove its cache
  # directly; environments are transparently rebuilt on the next pre-commit run
  log_info "Clearing pre-commit caches..."
  rm -rf ~/.cache/pre-commit

  if [[ "$*" == *--skip-nix-store* ]]; then
    log_info "Skipping Nix store clearing..."
  else
    log_info "Clearing Nix store..."
    nix-store --gc
  fi

  log_info "Clearing DotSlash cache..."
  # DotSlash write-protects its extracted artifacts - restore write perms so rm can unlink
  chmod -R u+w ~/Library/Caches/dotslash 2> /dev/null
  rm -rf ~/Library/Caches/dotslash

  log_info "Removing leaked Codex marketplace staging dirs..."
  find ~/.codex/.tmp/bundled-marketplaces -maxdepth 1 -type d -name 'openai-bundled.staging-*' -mtime +2 -exec rm -rf {} + 2> /dev/null

  log_info "Removing Bazel output bases of deleted workspaces..."
  local bazel_output_base bazel_workspace
  for bazel_output_base in ~/Library/Caches/bazel/_bazel_"$USER"/*(N/); do
    [[ -f "$bazel_output_base/DO_NOT_BUILD_HERE" ]] || continue
    bazel_workspace=$(<"$bazel_output_base/DO_NOT_BUILD_HERE")
    if [[ ! -d "$bazel_workspace" ]]; then
      log_debug "Workspace $bazel_workspace no longer exists. Removing its output base ($(du -sh "$bazel_output_base" | awk '{print $1}'))..."
      # Bazel write-protects its output tree (dirs included), and rm needs parent-dir
      # write permission to unlink - restore owner write perms first
      chmod -R u+w "$bazel_output_base" 2> /dev/null
      rm -rf "$bazel_output_base"
    fi
  done

  # A running Bazel server (one per workspace; they linger ~3h after the last command)
  # may be mid-fetch in the shared caches below, so never delete under it. The server
  # command line names its workspace, which makes for an actionable warning.
  local bazel_servers
  # Servers are named `bazel(<workspace>)`; anchoring on that keeps this grep from
  # matching its own command line
  bazel_servers=$(ps -axo command | grep -E '^bazel\([^)]*\) .*A-server\.jar' | sed -n 's/.*--workspace_directory=\([^ ]*\).*/\1/p' | sort -u | tr '\n' ' ')

  # Bazel 9 keeps two things under cache/repos/v1: `contents/` (extracted repos, which
  # Bazel itself garbage-collects after 14 idle days - --repo_contents_cache_gc_max_age)
  # and `content_addressable/` (raw downloads, never GC'd). Bazel touches an entry's
  # `file` on every cache hit, so its mtime is the last use; a pruned entry simply
  # re-downloads the next time a build needs it.
  local bazel_download bazel_download_count=0
  if [[ -n "$bazel_servers" ]]; then
    log_warning "Bazel servers are running for: $bazel_servers"
    log_warning "Skipping the Bazel repository-cache prune (run 'bazel shutdown' in those workspaces first)."
  else
    log_info "Pruning Bazel repository-cache downloads unused for 90+ days..."
    for bazel_download in ~/Library/Caches/bazel/_bazel_"$USER"/cache/repos/v1/content_addressable/sha256/*/file(N.m+90); do
      rm -rf "${bazel_download:h}"
      (( bazel_download_count += 1 ))
    done
    log_debug "Pruned $bazel_download_count stale download(s)."
  fi

  # Exact match: `--bazel-clean-canva` must not trigger the wipe
  if (( ${@[(Ie)--bazel]} )); then
    if [[ -n "$bazel_servers" ]]; then
      log_warning "Bazel servers are running for: $bazel_servers"
      log_warning "Skipping the Bazel build-cache wipe (run 'bazel shutdown' in those workspaces and re-run with --bazel)."
    else
      # Rarely needed: Canva's generated bazelrc caps the disk cache
      # (--experimental_disk_cache_gc_max_size=250G) and Bazel GCs both repo-contents
      # caches after 14 idle days (the main checkout uses the default cache/repos/v1/contents;
      # older worktree rcs still point at ~/.cache/canva_bazel_repo_contents_cache).
      log_info "Wiping Bazel build caches (next builds will run cold)..."
      # Same story: parts of these caches are write-protected
      chmod -R u+w ~/.cache/canva_bazel_disk_cache ~/.cache/canva_bazel_repo_contents_cache ~/Library/Caches/bazel/_bazel_"$USER"/cache 2> /dev/null
      rm -rf ~/.cache/canva_bazel_disk_cache ~/.cache/canva_bazel_repo_contents_cache ~/Library/Caches/bazel/_bazel_"$USER"/cache
    fi
  else
    log_info "Skipping Bazel build caches (pass --bazel to also wipe them)..."
  fi

  if [[ "$*" == *--bazel-clean-canva* ]]; then
    # `clean` drops the checkout's build outputs (execroot/bazel-out, ~18GB) and keeps its
    # fetched external repos (another ~18GB; `clean --expunge` would take both plus the
    # server state). The next build recompiles, mostly from the disk/remote cache.
    # --noblock_for_lock fails fast instead of queueing behind - and then wiping the
    # outputs of - a build another session is running in this checkout.
    log_info "Cleaning the canva monorepo's Bazel build outputs (next build runs cold)..."
    (cd ~/work/canva && bazel --noblock_for_lock clean) || log_warning "bazel clean did not run - is another Bazel command active in ~/work/canva?"
  fi

  if [[ "$*" == *--canva-git* ]]; then
    # Consolidates all reachable objects into one pack and drops unreachable objects
    # (e.g. orphaned AI-agent snapshot blobs) older than 30 days. Keeps a cruft pack
    # as a 30-day safety net for recent unreachables. See the 2026-08-06 cleanup that
    # took .git from 87GB to 23GB. Safe to run while working in the repo.
    log_info "Cruft-repacking the canva monorepo (takes ~30 min)..."
    git -C ~/work/canva repack -d --cruft --cruft-expiration=30.days.ago --write-midx
    # The hourly `git maintenance` split commit-graph still lists the commits the repack
    # just expired, which makes `git fsck` / `commit-graph verify` complain ("Could not
    # read <sha>") until the chain is rebuilt from reachable commits (2026-09-11)
    log_info "Rebuilding the canva monorepo's commit-graph..."
    git -C ~/work/canva commit-graph write --reachable --split=replace
  fi

  if docker stats --no-stream &> /dev/null; then
    log_info "Removing docker's unused data..."
    docker system prune --volumes
  else
    log_warning "Docker is not running. Skipping docker's unused data removal."
  fi

  log_info "Clearing Simulator data..."
  xcrun simctl delete unavailable
  if [[ -n $(/bin/ls -A ~/Library/Developer/CoreSimulator/Caches) ]]; then
    log_warning "Directory ~/Library/Developer/CoreSimulator/Caches is not empty! ($(du -sh ~/Library/Developer/CoreSimulator/Caches | awk '{print $1}'))"
    echo "You can remove them manually if you want, or run the following command to permanently delete all files and subdirectories:"
    echo "rm -rf ~/Library/Developer/CoreSimulator/Caches/*"
  fi
}
