################################################################################
# Base dependencies
################################################################################
brew "mas"


################################################################################
# CLI and Dev Tools
################################################################################

# Shells  ---
brew "bash"
brew "bash-completion@2"
brew "zsh"

# Installing GNU utils  ---
brew "coreutils"    # PATH="$BREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"
brew "findutils"    # PATH="$BREW_PREFIX/opt/findutils/libexec/gnubin:$PATH"
brew "gnu-sed"      # PATH="$BREW_PREFIX/opt/gnu-sed/libexec/gnubin:$PATH"
brew "gnu-tar"      # PATH="$BREW_PREFIX/opt/gnu-tar/libexec/gnubin:$PATH"
brew "grep"         # PATH="$BREW_PREFIX/opt/grep/libexec/gnubin:$PATH"
brew "moreutils"

# Installing more recent versions of some macOS tools  ---
brew "vim"
brew "openssh"
brew "screen"
brew "gmp"

# Python dev tools  ---
brew "pyenv"
brew "pipx"     # https://github.com/pypa/pipx/

# openjdk (Java's development kit)  ---
brew "openjdk@11"

# Fonts  ---
tap "bramstein/webfonttools"
brew "sfnt2woff"
brew "sfnt2woff-zopfli"
brew "woff2"
brew "svn"
tap "homebrew/cask-fonts"
cask "font-oswald"
cask "font-open-sans"
cask "font-lora"
cask "font-juliamono"
cask "font-hack-nerd-font"

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
brew "ciphey"               # https://github.com/Ciphey/Ciphey
brew "openssl@1.1"          # https://www.openssl.org/
brew "readline"
brew "sqlite"
brew "golang"               # old unavailable flag: --cross-compile-common
brew "ruby"
brew "pandoc"		        # https://github.com/jgm/pandoc
brew "graphviz"
brew "postgresql@14"        # https://www.postgresql.org/
brew "node"
brew "kcat"                 # https://github.com/edenhill/kcat
brew "protobuf"             # https://github.com/protocolbuffers/protobuf/
brew "yarn"
brew "redis"
brew "mackup"               # https://github.com/lra/mackup
brew "jq"                   # https://stedolan.github.io/jq/
brew "watch"                # https://gitlab.com/procps-ng/procps
brew "pv"                   # https://www.ivarch.com/programs/pv.shtml
brew "hugo"                 # https://gohugo.io/getting-started/installing/
brew "asciinema"            # https://asciinema.org
brew "gimme-aws-creds"      # https://github.com/Nike-Inc/gimme-aws-creds
brew "ffmpeg"
brew "thefuck"
brew "ncdu"                 # https://dev.yorhel.nl/ncdu
brew "shellcheck"           # https://github.com/koalaman/shellcheck
brew "bat"                  # https://github.com/sharkdp/bat
brew "awscli"
brew "gh"                   # https://github.com/cli/cli
brew "act"                  # https://github.com/nektos/act
brew "autojump"             # https://github.com/wting/autojump
brew "libfaketime"          # https://github.com/wolfcw/libfaketime
brew "gource"               # https://github.com/acaudwell/Gource
tap "homebrew/command-not-found"

# git  ---
brew "git"
brew "git-crypt"
brew "gnupg"
brew "pinentry-mac"
brew "git-lfs"
brew "git-flow-avh"
brew "git-filter-repo"      # https://github.com/newren/git-filter-repo
brew "multi-git-status"     # https://github.com/fboender/multi-git-status
brew "git-delta"            # https://github.com/dandavison/delta

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
# Other terminal emulators to consider:
# - [alacritty](https://github.com/alacritty/alacritty) - A cross-platform, GPU-accelerated terminal emulator
# - [Tabby](https://github.com/Eugeny/tabby) - A terminal for a more modern age
cask "iterm2"                   # https://iterm2.com/
cask "go2shell"                 # https://zipzapmac.com/go2shell

# Docker and virtualbox  ---
cask "docker"
cask "kitematic"
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


################################################################################
# Desktop Applications
################################################################################

# Drivers  ---
cask "logi-options-plus"

# Text editors and IDEs  ---
cask "jetbrains-toolbox"
cask "visual-studio-code"
cask "sublime-text"
cask "r"
mas "Xcode", id: 497799835

# Other desktop dev tools  ---
cask "anaconda"
cask "jupyter-notebook-viewer"  # https://github.com/tuxu/nbviewer-app
cask "postman"
cask "proxyman"                 # https://github.com/ProxymanApp/Proxyman

# Quick-look plugins  ---
cask "syntax-highlight"
cask "qlstephen"
cask "qlmarkdown"
cask "qlimagesize"
cask "qlvideo"

# Web Browsers  ---
cask "brave-browser"
cask "google-chrome"
#cask "tor-browser"
cask "firefox"
# Safari extensions:
mas "Grammarly for Safari", id: 1462114288
mas "Dashlane – Password Manager", id: 517914548

# Productivity & Office apps  ---
cask "microsoft-office"
cask "the-unarchiver"
cask "whatsapp"
cask "slack"
cask "raycast"                  # https://www.raycast.com/
cask "skitch"
cask "the-unarchiver"
cask "whatsapp"
cask "google-drive"
cask "notion"
cask "raindropio"
cask "zoom"
cask "rectangle"                # https://github.com/rxhanson/Rectangle
cask "zotero"                   # https://www.zotero.org/
mas "Pages", id: 409201541
mas "Numbers", id: 409203825
mas "Keynote", id: 409183694

# Misc apps  ---
cask "macs-fan-control"
#cask "vuze"
cask "transmission"             # https://transmissionbt.com/
cask "spotify"
cask "vlc"
cask "iina"                     # https://iina.io/
cask "appcleaner"
cask "betterdisplay"            # https://github.com/waydabber/BetterDisplay
cask "disk-inventory-x"
cask "imageoptim"               # https://github.com/ImageOptim/ImageOptim
cask "pdf-squeezer"             #
cask "image2icon"               # https://img2icnsapp.com/
cask "p4v"
cask "diffmerge"
cask "thorium"                  # https://github.com/edrlab/thorium-reader
cask "zotero"
#tap "popcorn-official/popcorn-desktop", "https://github.com/popcorn-official/popcorn-desktop.git"
#cask "popcorn-time"
mas "Amphetamine", id: 937984704
mas "GIPHY CAPTURE", id: 668208984
mas "Todoist", id: 585829637
