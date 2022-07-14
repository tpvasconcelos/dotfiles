################################################################################
# Base dependencies
################################################################################
tap "homebrew/cask"
brew "mas"


################################################################################
# CLI and Dev Tools
################################################################################

# Shells  ---
brew "bash"
brew "bash-completion2"
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

# Install python dev tools  ---
brew "pyenv"
brew "pipx"     # https://github.com/pypa/pipx/

# Installing openjdk (Java's development kit)  ---
brew "openjdk@11"

# Installing cool fonts  ---
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

# Installing useful more command line utils  ---
brew "curl"
brew "wget"
brew "grpc"                 # https://github.com/grpc/grpc/blob/master/doc/command_line_tool.md
brew "htop"
brew "iproute2mac"          # macos wrapper to the linux `ip` utility (https://github.com/brona/iproute2mac)
brew "tree"
brew "neovim"               # https://github.com/neovim/neovim
brew "glow"                 # https://github.com/charmbracelet/glow
brew "fzf"                  # https://github.com/junegunn/fzf
brew "ciphey"               # https://github.com/Ciphey/Ciphey
brew "openssl"
brew "readline"
brew "sqlite"
brew "golang"               # old unavailable flag: --cross-compile-common
brew "ruby"
brew "graphviz"
brew "postgresql"
brew "node"
tap "dart-lang/dart"
brew "dart"
brew "kafkacat"             # https://github.com/edenhill/kafkacat
brew "protobuf"             # https://github.com/protocolbuffers/protobuf/
brew "yarn"
brew "redis"
brew "mackup"
brew "jq"                   # https://stedolan.github.io/jq/
brew "watch"                # https://gitlab.com/procps-ng/procps
brew "pv"                   # https://www.ivarch.com/programs/pv.shtml
brew "hugo"                 # https://gohugo.io/getting-started/installing/
brew "ffmpeg"
brew "thefuck"
brew "ncdu"                 # https://dev.yorhel.nl/ncdu
brew "shellcheck"           # https://github.com/koalaman/shellcheck
brew "bat"                  # https://github.com/sharkdp/bat
brew "awscli"
brew "cookiecutter"
brew "gh"                   # https://github.com/cli/cli
brew "act"                  # https://github.com/nektos/act
brew "autojump"             # https://github.com/wting/autojump
brew "libfaketime"          # https://github.com/wolfcw/libfaketime
tap "homebrew/command-not-found"

# Upgrading git  ---
brew "git"
brew "git-crypt"
brew "gnupg"
brew "pinentry-mac"
brew "git-lfs"
brew "git-flow-avh"

# Installing compilers  ---
brew "cmake"
brew "llvm"
brew "gcc"
brew "libomp"
brew "swig"

# Installing iTerm2  ---
# Other terminal emulators to consider:
# - [alacritty](https://github.com/alacritty/alacritty) - A cross-platform, GPU-accelerated terminal emulator
cask "iterm2"

# Installing docker and virtualbox  ---
cask "docker"
cask "kitematic"
cask "virtualbox"

# Installing Kubernetes dev tools  ---
brew "kubectx"                  # https://github.com/ahmetb/kubectx
brew "k9s"                      # https://github.com/derailed/k9s
brew "kube-ps1"                 # https://github.com/jonmosco/kube-ps1
brew "aws-iam-authenticator"    # https://github.com/kubernetes-sigs/aws-iam-authenticator
tap "ubuntu/microk8s"
cask "multipass"                # https://multipass.run/
brew "microk8s"                 # https://microk8s.io/
brew "helm"                     # https://github.com/helm/helm
brew "kustomize"                # https://github.com/kubernetes-sigs/kustomize
brew "kind"                     # https://github.com/kubernetes-sigs/kind/


################################################################################
# Desktop Applications
################################################################################

# Installing drivers  ---
tap "homebrew/cask-drivers"
cask "logitech-options"

# Installing Text editors and IDEs  ---
cask "jetbrains-toolbox"
cask "visual-studio-code"
cask "sublime-text"
cask "r"

# Quick-look plugins  ---
cask "syntax-highlight"
cask "qlstephen"
cask "qlmarkdown"
cask "qlimagesize"
cask "qlvideo"

# Other dev applications  ---
cask "anaconda"

# Installing Browsers  ---
cask "brave-browser"
cask "google-chrome"
cask "tor-browser"
cask "firefox"
# Safari extensions:
mas "Grammarly for Safari", id: 1462114288
mas "Dashlane – Password Manager", id: 517914548

# Installing Productivity & Office apps  ---
cask "microsoft-office"
cask "the-unarchiver"
cask "whatsapp"
cask "slack"
cask "alfred"
cask "skitch"
cask "the-unarchiver"
cask "whatsapp"
cask "google-drive"
cask "notion"
cask "raindropio"
cask "zoom"
cask "rectangle"        # https://github.com/rxhanson/Rectangle

# Installing Misc apps  ---
cask "macs-fan-control"
cask "vuze"
cask "spotify"
cask "vlc"
cask "iina"                     # https://iina.io/
cask "adobe-creative-cloud"
cask "blender"
cask "appcleaner"
cask "disk-inventory-x"
cask "muzzle"
cask "proxyman"                 # https://github.com/ProxymanApp/Proxyman
cask "imageoptim"               # https://github.com/ImageOptim/ImageOptim
cask "pdf-squeezer"             #
cask "image2icon"               # https://img2icnsapp.com/
cask "p4v"
cask "diffmerge"
cask "postman"
cask "jupyter-notebook-viewer"  # https://github.com/tuxu/nbviewer-app
cask "eul"                      # https://github.com/gao-sun/eul/
#tap "popcorn-official/popcorn-desktop", "https://github.com/popcorn-official/popcorn-desktop.git"
#cask "popcorn-time"
mas "Amphetamine", id: 937984704
mas "GIPHY CAPTURE", id: 668208984
mas "Todoist", id: 585829637
