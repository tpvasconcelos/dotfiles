# https://confluence.atlassian.com/bitbucket/set-up-an-ssh-key-728138079.html#SetupanSSHkey-ssh2

yes | ssh-keygen -P "" -f ~/.ssh/id_rsa
eval `ssh-agent`
ssh-add -k ~/.ssh/id_rsa
echo "Host *\n  IgnoreUnknown UseKeychain\n  UseKeychain yes" > ~/.ssh/config

# here we are copying the public key to the clipboard
# after running this, add it to your bitbucket SSSH keys
pbcopy < ~/.ssh/id_rsa.pub