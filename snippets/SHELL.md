# Shell Snippets

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