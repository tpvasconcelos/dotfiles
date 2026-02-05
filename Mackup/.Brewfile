################################################################################
# Base dependencies
################################################################################

# mas is a CLI for the Mac App Store
brew "mas"


################################################################################
# CLI and Dev Tools
################################################################################

# Shells  ---
brew "bash"
brew "bash-completion@2"
brew "zsh"

# Basic utils  ---
# There are a lot of formulas that depend on coreutils which makes it hard
# to migrate to uutils-coreutils for now (needs more investigation...)
brew "coreutils"            # PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
# brew "uutils-coreutils"   # PATH="/opt/homebrew/opt/uutils-coreutils/libexec/uubin:$PATH"
brew "uutils-findutils"     # PATH="/opt/homebrew/opt/uutils-findutils/libexec/uubin:$PATH"
brew "uutils-diffutils"     # PATH="/opt/homebrew/opt/uutils-diffutils/libexec/uubin:$PATH"
brew "gnu-sed"              # PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
brew "gnu-tar"              # PATH="/opt/homebrew/opt/gnu-tar/libexec/gnubin:$PATH"
brew "grep"                 # PATH="/opt/homebrew/opt/grep/libexec/gnubin:$PATH"
brew "eza"                  # https://github.com/eza-community/eza
brew "moreutils"

# Installing more recent versions of some macOS tools  ---
brew "vim"
brew "openssh"
brew "screen"
brew "gmp"
brew "rsync"                # https://rsync.samba.org/

# Python dev tools  ---
brew "pyenv"                # TODO: Remove this once uv completely replaces pyenv in tau
brew "uv"                   # https://github.com/astral-sh/uv

# openjdk (Java's development kit)  ---
brew "openjdk@11"

# Databases  ---
brew "sqlite"
brew "postgresql"           # https://www.postgresql.org/
brew "redis"

# Kafka tools  ---
brew "kcat"                 # https://github.com/edenhill/kcat

# Programming languages  ---
brew "golang"               # old unavailable flag: --cross-compile-common
brew "ruby"

# Javascript dev tools  ---
brew "node"
brew "yarn"

# Infra/DevOps tools  ---
brew "ansible"                      # https://www.ansible.com/
brew "checkov"                      # https://www.checkov.io/
tap "hashicorp/tap"
brew "hashicorp/tap/terraform"      # https://developer.hashicorp.com/terraform
brew "tflint"                       # https://github.com/terraform-linters/tflint
brew "trivy"                        # https://trivy.dev/
brew "minamijoyo/tfupdate/tfupdate" # https://github.com/minamijoyo/tfupdate
brew "hcloud"                       # https://github.com/hetznercloud/cli
brew "ssh-audit"                    # https://github.com/jtesta/ssh-audit
brew "direnv"                       # https://direnv.net/

# git  ---
brew "git"
brew "git-crypt"
brew "gnupg"
brew "pinentry-mac"
brew "git-lfs"
brew "git-filter-repo"      # https://github.com/newren/git-filter-repo
brew "multi-git-status"     # https://github.com/fboender/multi-git-status
brew "git-town"             # https://git-town.com/
brew "git-delta"            # https://github.com/dandavison/delta
brew "git-extras"           # https://github.com/tj/git-extras
brew "diff-so-fancy"        # https://github.com/so-fancy/diff-so-fancy

# Compilers and relevant binaries  ---
brew "cmake"
brew "llvm"
brew "gcc"
brew "libomp"
brew "swig"
brew "openblas"
brew "z3"           # https://github.com/Z3Prover/z3

# Extra requirements for building animations with the manim package
# https://docs.manim.community/en/stable/installation/macos.html
cask "mactex"

# Terminal emulators  ---
cask "iterm2"                   # https://iterm2.com/
cask "kitty"                    # https://githb.com/kovidgoyal/kitty
cask "alacritty"                # https://github.com/alacritty/alacritty
cask "ghostty"                  # https://github.com/ghostty-org/ghostty
# OpenInTerminal
cask "openinterminal-lite"      # https://github.com/Ji4n1ng/OpenInTerminal
cask "openineditor-lite"        # https://github.com/Ji4n1ng/OpenInTerminal

# Docker and virtualbox  ---
cask "docker-desktop"
#cask "virtualbox"

# Kubernetes dev tools  ---
brew "kubectl"                  # https://kubernetes.io/docs/tasks/tools/#kubectl
brew "kubectx"                  # https://github.com/ahmetb/kubectx
brew "k9s"                      # https://github.com/derailed/k9s
brew "kube-ps1"                 # https://github.com/jonmosco/kube-ps1
brew "aws-iam-authenticator"    # https://github.com/kubernetes-sigs/aws-iam-authenticator
brew "helm"                     # https://github.com/helm/helm
brew "kustomize"                # https://github.com/kubernetes-sigs/kustomize
brew "kind"                     # https://github.com/kubernetes-sigs/kind/

# Fun stuff  ---
brew "asciinema"            # https://asciinema.org
brew "libfaketime"          # https://github.com/wolfcw/libfaketime
brew "gource"               # https://github.com/acaudwell/Gource

# Fonts  ---
brew "woff2"
brew "svn"
cask "font-lora"
cask "font-open-sans"
cask "font-oswald"
cask "font-rounded-mplus"
cask "font-juliamono"
cask "font-fira-code-nerd-font"
cask "font-fira-mono-nerd-font"
cask "font-hack-nerd-font"
cask "font-jetbrains-mono-nerd-font"
cask "font-opendyslexic-nerd-font"
cask "font-roboto-mono-nerd-font"
cask "font-ubuntu-nerd-font"
cask "font-ubuntu-sans-nerd-font"

# Command line utils  ---
brew "curl"
brew "wget"
brew "croc"                 # https://github.com/schollz/croc
brew "grpc"                 # https://github.com/grpc/grpc/blob/master/doc/command_line_tool.md
brew "htop"
brew "iproute2mac"          # macos wrapper to the linux `ip` utility (https://github.com/brona/iproute2mac)
brew "tree"
brew "neovim"               # https://github.com/neovim/neovim
brew "glow"                 # https://github.com/charmbracelet/glow
brew "fzf"                  # https://github.com/junegunn/fzf
brew "openssl"              # https://www.openssl.org/
brew "readline"
brew "pandoc"		        # https://github.com/jgm/pandoc
brew "graphviz"
brew "protobuf"             # https://github.com/protocolbuffers/protobuf/
brew "mackup"               # https://github.com/lra/mackup
brew "jq"                   # https://stedolan.github.io/jq/
brew "watch"                # https://gitlab.com/procps-ng/procps
brew "pv"                   # https://www.ivarch.com/programs/pv.shtml
brew "hugo"                 # https://gohugo.io/getting-started/installing/
brew "gimme-aws-creds"      # https://github.com/Nike-Inc/gimme-aws-creds
brew "ffmpeg"
brew "ncdu"                 # https://dev.yorhel.nl/ncdu
brew "dust"                 # https://github.com/bootandy/dust
brew "dua-cli"              # https://github.com/Byron/dua-cli
brew "shellcheck"           # https://github.com/koalaman/shellcheck
brew "bat"                  # https://github.com/sharkdp/bat
brew "awscli"               # https://aws.amazon.com/cli/
cask "gcloud-cli"           # https://cloud.google.com/sdk/
brew "with-readline"        # https://www.greenend.org.uk/rjk/sw/withreadline.html
brew "gh"                   # https://github.com/cli/cli
brew "act"                  # https://github.com/nektos/act
brew "zoxide"               # https://github.com/ajeetdsouza/zoxide
brew "ripgrep"              # https://github.com/BurntSushi/ripgrep
brew "fd"                   # https://github.com/sharkdp/fd
brew "hyperfine"            # https://github.com/sharkdp/hyperfine
cask "soulver-cli"          # https://github.com/soulverteam/Soulver-CLI
brew "just"                 # https://github.com/casey/just
brew "unison"               # https://www.cis.upenn.edu/~bcpierce/unison/
brew "markdownlint-cli"     # https://github.com/DavidAnson/markdownlint

# Work  ---
brew "fluent-bit"


################################################################################
# Desktop Applications
################################################################################

# Drivers  ---
cask "logi-options+"

# Text editors and IDEs  ---
cask "jetbrains-toolbox"
cask "visual-studio-code"
cask "sublime-text"
cask "miaoyan"              # https://github.com/tw93/MiaoYan
cask "r-app"
#mas "Xcode", id: 497799835

# Other desktop dev tools  ---
cask "jupyter-notebook-viewer"  # https://github.com/tuxu/nbviewer-app
cask "postman"
cask "proxyman"                 # https://github.com/ProxymanApp/Proxyman
cask "devutils"                 # https://devutils.com/

# Quick-look plugins  ---
cask "syntax-highlight"         # https://github.com/sbarex/SourceCodeSyntaxHighlight
cask "qlvideo"                  # https://github.com/Marginal/QLVideo
cask "glance-chamburr"          # https://github.com/chamburr/glance

# Web Browsers  ---
cask "arc"
cask "google-chrome"
cask "firefox"
#cask "tor-browser"
cask "zen"
# Safari extensions:
mas "Grammarly for Safari", id: 1462114288
mas "Dashlane – Password Manager", id: 517914548
mas "HotspotShield VPN - Wifi Proxy", id: 771076721

# Productivity apps  ---
cask "anki"                                             # https://apps.ankiweb.net/
cask "the-unarchiver"
cask "shottr"                                           # https://shottr.cc/
cask "raycast"                                          # https://www.raycast.com/
cask "google-drive"
cask "raindropio"
cask "zotero"                                           # https://www.zotero.org/
cask "adobe-acrobat-reader"                             # https://www.adobe.com/acrobat/pdf-reader.html
cask "viz"                                              # https://github.com/alienator88/Viz
mas "TickTick:To-Do List, Calendar", id: 966085870      # https://www.ticktick.com/home
cask "todoist-app"                                      # https://www.todoist.com/home
cask "hammerspoon"                                      # https://www.hammerspoon.org/

# Office apps  ---
cask "anytype"
cask "notion"                   # https://www.notion.so/
cask "notion-calendar"
cask "obsidian"                 # https://obsidian.md/
cask "linear-linear"            # https://linear.app/
cask "microsoft-office"
cask "microsoft-auto-update"
cask "libreoffice"
mas "Pages", id: 409201541
mas "Numbers", id: 409203825
mas "Keynote", id: 409183694

# Social media, messaging, and communication apps  ---
cask "whatsapp"
cask "slack"
cask "zoom"

# Photo & video  ---
cask "diffusionbee"             # https://www.diffusionbee.com/
cask "upscayl"                  # https://upscayl.org/
cask "fujifilm-x-raw-studio"    # https://fujifilm-x.com/global/products/software/x-raw-studio/

# AI apps  ---
brew "ollama"                   # https://ollama.com/
cask "lm-studio"                # https://lmstudio.ai/
cask "chatgpt"                  # https://chatgpt.com/
cask "claude"                   # https://claude.ai/download
#cask "claude-code"              # https://claude.com/product/claude-code
brew "gemini-cli"               # https://github.com/google-gemini/gemini-cli
cask "codex"                    # https://github.com/openai/codex

# Misc apps  ---
cask "appcleaner"
cask "pearcleaner"                      # https://github.com/alienator88/Pearcleaner
cask "macs-fan-control"
cask "spotify"
cask "vlc"
cask "iina"                             # https://iina.io/
cask "calibre"                          # https://calibre-ebook.com/
cask "betterdisplay"                    # https://github.com/waydabber/BetterDisplay
cask "disk-inventory-x"
cask "imageoptim"                       # https://github.com/ImageOptim/ImageOptim
cask "pdf-squeezer"
cask "image2icon"                       # https://img2icnsapp.com/
cask "gimp"                             # https://www.gimp.org/
cask "p4v"
cask "diffmerge"
cask "thorium"                          # https://github.com/edrlab/thorium-reader
cask "istherenet"                       # https://lowtechguys.com/istherenet/
cask "alt-tab"                          # https://github.com/lwouis/alt-tab-macos
#cask "vuze"
cask "transmission"                     # https://transmissionbt.com/
cask "zotero"
mas "Amphetamine", id: 937984704
mas "GIPHY CAPTURE", id: 668208984
mas "Shareful", id: 1522267256
