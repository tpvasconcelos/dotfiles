# Shell Snippets


#### Ask for `sudo` password only once
Add this to the top of your shell script.
```shell script
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
```

#### Setup `ssh` for `git`
For more read the relevant docs
- [GitHub](https://help.github.com/en/articles/connecting-to-github-with-ssh)
- [Bitbucket](https://confluence.atlassian.com/bitbucket/set-up-an-ssh-key-728138079.html#SetupanSSHkey-ssh2)
- [GitLab](https://docs.gitlab.com/ee/ssh/)
```shell script
yes | ssh-keygen -P "" -f ~/.ssh/id_rsa
eval "$(ssh-agent)"
ln -shfv "$(realpath preferences/ssh/config)" ~/.ssh
/usr/bin/ssh-add -K ~/.ssh/id_rsa

# Here, we are copying the public key to the clipboard.
# After running this, add it to your bitbucket/github SSH keys!
pbcopy < ~/.ssh/id_rsa.pub
```


#### `ffmpeg` - Video from images
```shell script
ffmpeg -framerate 24.994862 -i img%06d.png -c:v libx264 -vf fps=24.994862 -pix_fmt yuv420p myMovie.mp4
```


#### Remove local CloudDocs copies
```shell script
# $ source ~/.zshrc

function _safer_evict() {
  input_path=$(realpath "$@")/
  # shellcheck disable=SC2034
  path_to_icloud=$(realpath ~/Library/Mobile\ Documents/com~apple~CloudDocs)/
  if [[ "${input_path##path_to_icloud}" != "${input_path}" ]]; then
    echo yes;
    echo "$input_path";
  fi
}

function _evictall() {
  _SAFER_EVICT=$(functions _safer_evict)
  #find "$1" -type f -not -name .DS_Store -a -not -name .\*.icloud -exec "$SHELL" -c '_safer_evict "$@"' -- {} \;
  #find "$1" -type f -not -name .DS_Store -a -not -name .\*.icloud -exec zsh -c '_safer_evict "$@"' zsh {} \;
  #  find "$1" -type f -not -name .DS_Store -a -not -name .\*.icloud -print0 | xargs -0 ls
  #find "$1" -type f -not -name .DS_Store -a -not -name .\*.icloud -print0 | xargs -0 bash -c '_safer_evict "$@"' _
  #find "$1" -type f -not -name .DS_Store -a -not -name .\*.icloud -print0 | xargs -0 -I{} "$SHELL" -c "eval $_SAFER_EVICT; _safer_evict {}"
  find "$1" -type f -not -name .DS_Store -a -not -name .\*.icloud -print0 | xargs -0 -I{} "$SHELL" -c "eval ${_SAFER_EVICT}; ls {}"
}

_evictall "$1"

```