# https://help.github.com/en/articles/connecting-to-github-with-ssh
# https://confluence.atlassian.com/bitbucket/set-up-an-ssh-key-728138079.html#SetupanSSHkey-ssh2

yes | ssh-keygen -P "" -f ~/.ssh/id_rsa
eval `ssh-agent`
echo -e "Host *\n  IgnoreUnknown UseKeychain\n  AddKeysToAgent yes\n  UseKeychain yes\n  IdentityFile ~/.ssh/id_rsa" > ~/.ssh/config
/usr/bin/ssh-add -K ~/.ssh/id_rsa

# Here, we are copying the public key to the clipboard.
# After running this, add it to your bitbucket/github SSH keys!
pbcopy < ~/.ssh/id_rsa.pub
