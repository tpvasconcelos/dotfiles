#!/usr/bin/env zsh
set -eu

_generate_ssh_key() {
  local email
  echo -n "Enter your email address: "
  read -r email
  log_info "Generating a new SSH key for: $email"
  cat <<EOF
To add an extra layer of security, you will be prompted to enter a passphrase
for the SSH key. Note that we will add the key to the macOS keychain and to
the ssh-agent for you, so you won't have to enter the passphrase every time
you use the key. If you want to change this behaviour, you can do so by
editing the ~/.ssh/config file.
EOF
  ssh-keygen -t ed25519 -C "$email" -f "${SSH_IDENTITY_FILE}"
  eval "$(ssh-agent -s)"
  /usr/bin/ssh-add --apple-use-keychain "${SSH_IDENTITY_FILE}"
  log_success "Successfully generated and added SSH key to keychain: ${SSH_IDENTITY_FILE}"
}

_add_key_to_gh() {
  if ! gh auth status &>/dev/null; then
    log_warning "You need to authenticate the GitHub CLI before adding the SSH key."
    gh auth login
  fi
  default_title="$(id -un)@$(hostname) - $(date +'%Y-%m-%d %H:%M:%S')"
  echo -n "Enter a title for the SSH key (default: ${default_title}): "
  read -r title
  title="${title:-$default_title}"
  log_info "Expanding GitHub CLI scope to admin:public_key"
  gh auth refresh -h github.com -s admin:public_key
  log_info "Adding SSH key to GitHub with title: ${title}"
  gh ssh-key add "${SSH_IDENTITY_FILE}.pub" --title "${title}"
}

if [[ -z "${SSH_IDENTITY_FILE:-}" ]]; then
  SSH_IDENTITY_FILE="$HOME/.ssh/id_ed25519"
fi

if [[ -r "${SSH_IDENTITY_FILE}" ]]; then
  log_success "Found existing SSH key at: ${SSH_IDENTITY_FILE}"
else
  echo
  echo "No SSH key found at '${SSH_IDENTITY_FILE}'"
  if ask-yesno "Would you like to generate a new one now?"; then
    _generate_ssh_key
    if ask-yesno "Would you like to add the SSH key to GitHub?"; then
      _add_key_to_gh
    fi
  else
    log_warning "Continuing without generating an SSH key..."
  fi
fi
