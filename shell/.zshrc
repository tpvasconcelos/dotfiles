# Copy to home folder
# $ cp shell/.zshrc ~/.zshrc  && source ~/.zshrc

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# Path to your oh-my-zsh installation.
export ZSH="/Users/tpvasconcelos/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh
source "${HOME}/.iterm2_shell_integration.zsh"
source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


ZSH_THEME="powerlevel10k/powerlevel10k"

ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/usr/local/share/zsh-syntax-highlighting/highlighters


# /System/Volumes/Data/Users/tpvasconcelos/.oh-my-zsh
# /Users/tpvasconcelos/.oh-my-zsh
plugins=(
  # custom  ---
  poetry
  git
  iterm2
  docker
  man
  osx
  python
  composer
  # all  ---
#   adb
#   alias-finder
#   ansible
#   ant
#   apache2-macports
#   arcanist
#   archlinux
#   asdf
#   autoenv
#   autojump
#   autopep8
#   aws
#   battery
#   bazel
#   bbedit
#   bgnotify
#   boot2docker
#   bower
#   branch
#   brew
#   bundler
#   cabal
#   cake
#   cakephp3
#   capistrano
#   cargo
#   cask
#   catimg
#   celery
#   chruby
#   chucknorris
#   cloudfoundry
#   codeclimate
#   coffee
#   colemak
#   colored-man-pages
#   colorize
#   command-not-found
#   common-aliases
#   compleat
#   composer
#   copybuffer
#   copydir
#   copyfile
#   cp
#   cpanm
#   dash
#   debian
#   dircycle
#   direnv
#   dirhistory
#   dirpersist
#   django
#   dnf
#   dnote
#   docker-compose
#   docker-machine
#   docker
#   doctl
#   dotenv
#   dotnet
#   droplr
#   drush
#   eecms
#   emacs
#   ember-cli
#   emoji-clock
#   emoji
#   emotty
#   encode64
#   extract
#   fabric
#   fancy-ctrl-z
#   fasd
#   fastfile
#   fbterm
#   fd
#   firewalld
#   flutter
#   forklift
#   fossil
#   frontend-search
#   fzf
#   gas
#   gatsby
#   gb
#   gcloud
#   geeknote
#   gem
#   git-auto-fetch
#   git-escape-magic
#   git-extras
#   git-flow-avh
#   git-flow
#   git-hubflow
#   git-prompt
#   git
#   gitfast
#   github
#   gitignore
#   glassfish
#   globalias
#   gnu-utils
#   golang
#   gpg-agent
#   gradle
#   grails
#   grunt
#   gulp
#   hanami
#   helm
#   heroku
#   history-substring-search
#   history
#   hitokoto
#   homestead
#   httpie
#   ionic
#   iterm2
#   jake-node
#   jenv
#   jfrog
#   jhbuild
#   jira
#   jruby
#   jsontools
#   jump
#   kate
#   keychain
#   kitchen
#   knife_ssh
#   knife
#   kops
#   kube-ps1
#   kubectl
#   laravel
#   laravel4
#   laravel5
#   last-working-dir
#   lein
#   lighthouse
#   lol
#   lxd
#   macports
#   magic-enter
#   man
#   marked2
#   mercurial
#   meteor
#   microk8s
#   minikube
#   mix-fast
#   mix
#   mosh
#   mvn
#   mysql-macports
#   n98-magerun
#   nanoc
#   ng
#   nmap
#   node
#   nomad
#   npm
#   npx
#   nvm
#   oc
#   osx
#   otp
#   pass
#   paver
#   pep8
#   per-directory-history
#   percol
#   perl
#   perms
#   phing
#   pip
#   pipenv
#   pj
#   please
#   pod
#   postgres
#   pow
#   powder
#   powify
#   profiles
#   pyenv
#   pylint
#   python
#   rails
#   rake-fast
#   rake
#   rand-quote
#   rbenv
#   rbfu
#   react-native
#   rebar
#   redis-cli
#   repo
#   ripgrep
#   ros
#   rsync
#   ruby
#   rust
#   rustup
#   rvm
#   safe-paste
#   salt
#   sbt
#   scala
#   scd
#   screen
#   scw
#   sdk
#   sfdx
#   sfffe
#   shell-proxy
#   shrink-path
#   singlechar
#   spring
#   sprunge
#   ssh-agent
#   stack
#   sublime
#   sudo
#   supervisor
#   suse
#   svcat
#   svn-fast-info
#   svn
#   swiftpm
#   symfony
#   symfony2
#   systemadmin
#   systemd
#   taskwarrior
#   terminitor
#   terraform
#   textastic
#   textmate
#   thefuck
#   themes
#   thor
#   tig
#   timer
#   tmux-cssh
#   tmux
#   tmuxinator
#   torrent
#   transfer
#   tugboat
#   ubuntu
#   ufw
#   urltools
#   vagrant-prompt
#   vagrant
#   vault
#   vi-mode
#   vim-interaction
#   virtualenv
#   virtualenvwrapper
#   vscode
#   vundle
#   wakeonlan
#   wd
#   web-search
#   wp-cli
#   xcode
#   yarn
#   yii
#   yii2
#   yum
#   z
#   zeus
#   zsh_reload
#   zsh-interactive-cd
#   zsh-navigation-tools
)

# git autocomplete
# source ~/.zsh/_git/.git-prompt.sh
# source ~/.zsh/_git/.git-completion.zsh
# fpath=(~/.zsh/_git $fpath)Deploying to namespace: ci

fpath=(
    ~/.zsh/completion
    /usr/local/share/zsh/site-functions
    $fpath
)


# Fix PATH
export PATH="/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/mysql/bin:$PATH"
export PATH="/Library/TeX/texbin:$PATH"
export PATH="$HOME/mongodb/bin:$PATH"
export PATH="$HOME/.gem/ruby/2.7.0/bin:$PATH"
export PATH="$HOME/dev/flutter/bin:$PATH"
export PATH="$HOME/.poetry/bin:$PATH"
export PATH="/usr/local/opt/bin:$PATH"
export PATH="/usr/local/opt/bin:$PATH"
export PATH="/usr/local/opt/bin:$PATH"
export PATH="/usr/local/opt/bin:$PATH"
export PATH="/usr/local/opt/bin:$PATH"
#export PATH="/usr/local/opt/python3/bin:$PATH"
#export PATH="/usr/local/opt/python@3.7/bin:$PATH"
#export PATH="/usr/local/opt/python@3.8/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"

# Golang
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

# guile
export GUILE_LOAD_PATH="/usr/local/share/guile/site/3.0"
export GUILE_LOAD_COMPILED_PATH="/usr/local/lib/guile/3.0/site-ccache"
export GUILE_SYSTEM_EXTENSIONS_PATH="/usr/local/lib/guile/3.0/extensions"
export GUILE_TLS_CERTIFICATE_DIRECTORY=/usr/local/etc/gnutls/

# X13 ARIMA-SEATS
export PATH="$HOME/x13as/bin/:$PATH"
export X13PATH="$HOME/x13as/bin/"

# Ruby
export PATH="/usr/local/opt/ruby/bin:$PATH"
eval "$(rbenv init -)"

# pyenv
export PYENV_ROOT=$(pyenv root)
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi


##############################################################################
# History Configuration
##############################################################################
HISTFILE=~/.zsh_history         # Where to save history to disk
HISTSIZE=4096                   # How many lines of history to keep in memory
SAVEHIST=4096                   # Number of history entries to save to disk
HISTDUP=erase                   # Erase duplicates in the history file
setopt appendhistory            # Append history to the history file (no overwriting)
setopt INC_APPEND_HISTORY       # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY            # Share history between all sessions.
setopt BANG_HIST                # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY         # Write the history file in the ":start:elapsed;command" format.
setopt HIST_EXPIRE_DUPS_FIRST   # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS         # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS     # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS        # Do not display a line previously found.
setopt HIST_IGNORE_SPACE        # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS        # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS       # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY              # Don't execute immediately upon history expansion.
setopt HIST_BEEP                # Beep when accessing nonexistent history.
export ERL_AFLAGS="-kernel shell_history enabled"



# ENV Variables
export LANG="en_US.UTF-8"
# Tiqets
export TIQETS_ENV="tomas"


# Aliases  ---
alias ls='ls -G -la'
alias gotodsdir='cd $(find . -name "*$(git branch | grep \* | cut -d '-' -f2)*" -not -path "./.*" | head -n 1)'
alias path='echo $PATH | tr -s ":" "\n"'
alias pag='ps aux | head -1; ps aux | grep -v grep | grep'
eval $(thefuck --alias)


# Functions  ---
function py2nb() {
  jupytext --to notebook $1
  jupytext --sync $1
}

function nb2py() {
  jupytext --to py:percent $1
  jupytext --sync $1
}

function login-ec2() {
  AWS_PROFILE=data-eng aws ssm start-session --target i-"$1"
}

function mcd() {
  mkdir -p "$1" && cd "$1";
}

# CPP and LDF Flags and PKG_CONFIG_PATH  ---
# # openssl
# export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
# export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
# export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig"
# # readline
# export LDFLAGS="-L/usr/local/opt/readline/lib"
# export CPPFLAGS="-I/usr/local/opt/readline/include"
# export PKG_CONFIG_PATH="/usr/local/opt/readline/lib/pkgconfig"
# # sqlite
# export LDFLAGS="-L/usr/local/opt/sqlite/lib"
# export CPPFLAGS="-I/usr/local/opt/sqlite/include"
# export PKG_CONFIG_PATH="/usr/local/opt/sqlite/lib/pkgconfig"
# # llvm
# export LDFLAGS="-L/usr/local/opt/llvm/lib"
# export CPPFLAGS="-I/usr/local/opt/llvm/include"
# # zlib
# export LDFLAGS="-L/usr/local/opt/llvm/lib -Wl,-rpath,/usr/local/opt/llvm/lib"
# export LDFLAGS="-L/usr/local/opt/zlib/lib"
# export CPPFLAGS="-I/usr/local/opt/zlib/include"
# export PKG_CONFIG_PATH="/usr/local/opt/zlib/lib/pkgconfig"
# # MERGED
export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib -L/usr/local/opt/readline/lib -L/usr/local/opt/sqlite/lib -L/usr/local/opt/llvm/lib -L/usr/local/opt/zlib/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include -I/usr/local/opt/readline/include -I/usr/local/opt/sqlite/include -I/usr/local/opt/llvm/include -I/usr/local/opt/zlib/include"
export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig:/usr/local/opt/readline/lib/pkgconfig:/usr/local/opt/sqlite/lib/pkgconfig:/usr/local/opt/zlib/lib/pkgconfig"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
