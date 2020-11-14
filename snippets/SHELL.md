# Shell Snippets

#### `ffmpeg` - Video from images
```shell script
ffmpeg -framerate 24.994862 -i img%06d.png -c:v libx264 -vf fps=24.994862 -pix_fmt yuv420p myMovie.mp4
```
