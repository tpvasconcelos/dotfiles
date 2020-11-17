# My dotfiles

## References

* <https://github.com/grant/new-computer-checklist>
* <https://wiki.archlinux.org/index.php/Dotfiles>
* <https://github.com/unixorn/awesome-zsh-plugins>
* <https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html>


## Steps

### Install Xcode and Command Line Developer Tools
1. Download Xcode from the App Store, and run the following commands from the Terminal app:
1. Make sure `xcode-select` is pointing to the correct active developer directory
    ```shell script
    sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
    ```
1. Install the command line developer tools (this will open a user interface dialog)
    ```shell script
    xcode-select --install
    ```
1. Accept Xcode and SDK license agreements
    ```shell script
    sudo xcodebuild -license accept
    ```
1. Install extra packages
    ```shell script
    sudo xcodebuild -runFirstLaunch
    ```
1. Update everything. **Note:** if needed, this will automatically restart your computer!
    ```shell script
    sudo softwareupdate --install --all --verbose --force --restart
    ```


### Clone this repository
Clone this repository under `~/.dotfiles`
```shell script
mkdir ~/.dotfiles && \
  cd ~/.dotfiles && \
  git clone https://github.com/tpvasconcelos/dotfiles.git .
```


### Install iTerm

## Migrate app settings and system preferences

App settings:
1. Migrate all relevant config directories from `~/Library/Application\ Support`
2. Migrate all relevant app preferences from `~/Library/Preferences/`


References:
- https://intellij-support.jetbrains.com/hc/en-us/articles/206544519-Directories-used-by-the-IDE-to-store-settings-caches-plugins-and-logs


# Apps

Browsers
- Chrome
- Firefox
- Brave
- Tor

Social Networking
- Skype
- Slack
- WhatsApp
- Zoom
- Spark

Notes (and document viewers)
- DjView (alternative?)
- PDFpenPro (needed?)
- Notability
- Notion
- LaTeX Editor (Texpad)

Music
- gAssistant (alternative?)
- insTuner (alternative or make my own?)
- Logic Pro X

Photography
- Affinity Photo
- Adobe DNG Converter (needed?)
- Adobe Photoshop
- Adobe Lightroom Classic CC
- Adobe Lightroom CC

Video
- Subtitles
- VLC
- iMovie
- DaVinci Resolve

Graphics
- Blender
- Affinity Designer
- Adobe XD CC
- FontLab VI (still needed?)
- GIPHY CAPTURE (alternative?)
- Inkscape

Utilities
- Alfred
- Vuze
- Disk Inventory X
- Divvy (alternative?)
- File Viewer
- Go2Shell
- AppCleaner (alternative or make my own?)
- Kaleidoscope
	- p4merge
	- DiffMerge
- Skitch (alternative?)
- smcFanControl (alternative?)
- The Unarchiver (needed? alternative?)
- KeepingYouAwake (alternative? autoload)
- Speedify (is this actually good?)
- Muzzle (alternative?)
- Dashlane
- WiFi Explorer (alternative?)

IDEs
- Jetbrains Tool Box
- TextMate
- Sublime Text
- Visual Studio Code
- Xcode
- RStudio

Dev Tools
- iHex
- HDFView (alternative?)
- Virtualbox
- Jupyter Notebook Viewer

Office
- Microsoft Office
- Apple iWork
- 



