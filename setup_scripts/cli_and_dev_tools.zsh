#!/usr/bin/env zsh
set -eu

# ============================================================================
# --- Ask for root password upfront and keep updating the existing `sudo`
# --- timestamp on a background process until the script finishes. Note that
# --- you'll still need to use `sudo` where needed throughout the scripts.
# ============================================================================
echo "Some of the commands in this script require root access. Enter your password to unable root access when necessary..."
sudo -v
while true; do
  sudo -n true
  sleep 30
  kill -0 "$$" || exit
done 2>/dev/null &


echo "🚀 Installing GNU utils..."
brew install coreutils  # PATH="$BREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"
brew install findutils  # PATH="$BREW_PREFIX/opt/findutils/libexec/gnubin:$PATH"
brew install gnu-sed    # PATH="$BREW_PREFIX/opt/gnu-sed/libexec/gnubin:$PATH"
brew install gnu-tar    # PATH="$BREW_PREFIX/opt/gnu-tar/libexec/gnubin:$PATH"
brew install grep       # PATH="$BREW_PREFIX/opt/grep/libexec/gnubin:$PATH"
brew install moreutils

echo "🚀 Installing more recent versions of some macOS tools..."
brew install vim
brew install openssh
brew install screen
brew install gmp

echo "🚀 Installing Golang..."
brew install golang  # old unavailable flag: --cross-compile-common
mkdir -p "$HOME"/go/bin "$HOME"/go/src

echo "🚀 Installing cool fonts..."
# Error: Cask 'font-hack-nerd-font' is unavailable: No Cask with this name exists.
brew tap bramstein/webfonttools
brew install sfnt2woff
brew install sfnt2woff-zopfli
brew install woff2
brew install svn
brew tap homebrew/cask-fonts
brew install font-oswald font-open-sans font-lora
brew install --cask font-juliamono
brew install --cask font-hack-nerd-font

echo "🚀 Installing useful more command line utils..."
brew install wget
brew install htop
brew install tree
brew install glow     # https://github.com/charmbracelet/glow
brew install fzf      # https://github.com/junegunn/fzf
brew install openssl
brew install readline
brew install sqlite
brew install postgresql
brew install node
brew install yarn
brew install redis
brew install mackup
brew install mas
brew install ffmpeg
brew install thefuck
brew install ncdu               # https://dev.yorhel.nl/ncdu
brew install shellcheck         # https://github.com/koalaman/shellcheck
brew install pygments           # https://pygments.org/
brew install awscli
brew install pre-commit
brew install cookiecutter
brew tap fishtown-analytics/dbt && brew install dbt
go get -u github.com/alecthomas/chroma/cmd/chroma

echo "🚀 Upgrading git..."
brew install git
brew install git-crypt
brew install gpg
brew install git-lfs
git lfs install

echo "🚀 Installing compilers..."
brew install cmake
brew install llvm
brew install gcc
brew install libomp

echo " Installing iTerm2"
# Other terminal emulators to consider:
# - [alacritty](https://github.com/alacritty/alacritty) - A cross-platform, GPU-accelerated terminal emulator
brew install --cask iterm2
# Download Shell Integration and iTerm2 utilities
curl -L https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | bash

echo "🚀 Installing docker and virtualbox..."
brew install --cask docker
brew install --cask kitematic
brew install --cask virtualbox

echo "🚀 Installing Kubernetes... (well... not really...)"
brew install kubectx                  # https://github.com/ahmetb/kubectx
brew install derailed/k9s/k9s         # https://github.com/derailed/k9s
brew install kube-ps1                 # https://github.com/jonmosco/kube-ps1
brew install aws-iam-authenticator    # https://github.com/kubernetes-sigs/aws-iam-authenticator
brew install ubuntu/microk8s/microk8s # https://microk8s.io/
microk8s install -y
microk8s enable kubeflow              # https://www.kubeflow.org/
brew install helm                     # https://github.com/helm/helm
helm plugin install https://github.com/databus23/helm-diff --version master

echo "🚀 Installing Jekyll..."
# Jekyll - <https://jekyllrb.com/docs/installation/macos/>
brew install ruby
gem install --user-install bundler jekyll

echo "🚀 Installing Hugo..."
# Hugo - <https://gohugo.io/getting-started/installing/>
brew install hugo

echo "🚀 Installing Flutter..."
# Flutter - https://flutter.dev/docs/get-started/install/macos
# the next commands do not work... Probably something to do with current cpp compiler?
sudo gem install cocoapods
gem install cocoapods --user-install
pod setup
brew tap dart-lang/dart
brew install dart
git clone https://github.com/flutter/flutter.git -b stable --depth 1 ~/.flutter

echo "🚀 Installing R and RStudio..."
brew install --cask r
brew install --cask rstudio

echo "🚀 Installing graphviz..."
brew install graphviz

echo "🚀 update, upgrade, and cleanup..."
brew update && brew upgrade && brew cleanup
