# shellcheck disable=SC2034
########################################
# zsh plugins
########################################
# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  # Built-in  ---
  aws
  colored-man-pages
  command-not-found
  docker
  docker-compose
  extract
  flutter
  gitfast
  #gpg-agent
  golang
  httpie
  #keychain
  #kubectl
  microk8s
  #minikube
  npm
  pip
  postgres
  redis-cli
  #ssh-agent
  virtualenv

  # Custom  ---
  zsh-autosuggestions
  zsh-syntax-highlighting
)
