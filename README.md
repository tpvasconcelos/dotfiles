# My dotfiles


## Steps


### Clone this repository
Clone this repository under `~/.dotfiles`
```shell script
mkdir ~/.dotfiles && \
  cd ~/.dotfiles && \
  git clone https://github.com/tpvasconcelos/dotfiles.git .
```


### Install Xcode and Command Line Developer Tools
1. Start by downloading Xcode from the App Store. Once this download is complete, run the following shell 
commands from the Terminal app.
1. Here, we will install the Command Line Developer Tools. Note that the first command ensures 
`xcode-select` is pointing to the correct (active) developer directory. Follow the installation steps that 
will open in a user interface dialog.
    ```shell script
    sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
    xcode-select --install
    ```
1. As a final step, you'll need to accept the Xcode and SDK license agreements. The second command will also
install any missing packages.
    ```shell script
    sudo xcodebuild -license accept
    sudo xcodebuild -runFirstLaunch
    ```
1. This command will install all pending software updates for your machine. **Note that, if needed, this 
command will automatically restart your machine!**
    ```shell script
    sudo softwareupdate --install --all --verbose --force --restart
    ```


### Install Homebrew (brew)
```shell script
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew update && brew upgrade
```


### Install iTerm2
After installing iTerm2, you can switch to using the iTerm2 terminal emulater as oposed to Apple's Terminal 
app
```shell script
brew cask install iterm2
killall cfprefsd
# Migrate iTerm settings
cp settings/com.googlecode.iterm2.plist ~/Library/Preferences
# Download Shell Integration script
curl -L https://iterm2.com/shell_integration/zsh -o ~/.iterm2_shell_integration.zsh
```

Alternatives:
- [alacritty](https://github.com/alacritty/alacritty) - A cross-platform, GPU-accelerated terminal emulator


### Upgrade and configure shells
This script will install and configure more up-tp-date versions of the bash and zsh shells. Run this in 
the Iterm2 app installed in the previous step.
```shell script
./setup_scripts/setup_shells.sh
```

Create symlinks to your config files. **Warning: this will overwrite any existing config files.**
```shell script
ln -shfv "$(realpath .zshrc)" ~
ln -shfv "$(realpath .p10k.zsh)" ~
```

Here I'm using a bare [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh/) configuration with a 
[powerlevel10k](https://github.com/romkatv/powerlevel10k) theme. You can consider other frameworks, such as:
- [prezto](https://github.com/sorin-ionescu/prezto) - The configuration framework for Zsh
- [zinit](https://github.com/zdharma/zinit) - Ultra-flexible and fast Zsh plugin manager with clean fpath, 
reports, completion management, Turbo, annexes, services, packages.
- [zplug](https://github.com/zplug/zplug) - 🌺 A next-generation plugin manager for zsh
- [antibody](https://github.com/getantibody/antibody) - The fastest shell plugin manager.


### Update general macos preferences
This update many of the defualt macos settings and system preferences. Restart you machine after runnning 
this script.
```shell script
./setup_scripts/macos.sh
```

#### Security preferences
FileVault Service
```shell script
# Status
sudo fdesetup status
# Enable
sudo fdesetup enable
# Disable (Default)
sudo fdesetup disable
```
Firewall Service
```shell script
# Show Status
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate
# Enable
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
# Disable (Default)
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate off
```
Set Login Window Text
```shell script
sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "If lost, please contact tomasvasconcelos1@gmail.com"
```


### Migrate app settings and system preferences

App settings:
1. Migrate all relevant config directories from `~/Library/Application\ Support`
2. Migrate all relevant app preferences from `~/Library/Preferences/`


References:
- https://intellij-support.jetbrains.com/hc/en-us/articles/206544519-Directories-used-by-the-IDE-to-store-settings-caches-plugins-and-logs


### Update everything
**Note that, if needed, the first command will automatically restart your machine!**
```shell script
sudo softwareupdate --install --all --verbose --force --restart
```

Update any packages installed with brew
```shell script
brew update
brew upgrade
brew cask upgrade --greedy
brew cleanup
```


### Check for issues
Run `brew doctor` to check for any hanging issues
```shell script
brew doctor
```


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

## References

* [The "Hacker News Comment" Method](https://news.ycombinator.com/item?id=11070797) - This Hacker News comment
popularised the "bare repository and alias method" for managing dotfiles. This method is also references in
[Dotfiles (ArchWiki)](https://wiki.archlinux.org/index.php/Dotfiles).
* [Awesome macOS Command Line](https://github.com/herrbischoff/awesome-macos-command-line) - inspiration for 
most of the settings in [macos.sh](setup_scripts/macos.sh). Take everything in this repository with a pinch 
of salt. macOS is a fast-moving environment that does not prioritise backwards compatibility for these 
settings or preferences.
* <https://github.com/grant/new-computer-checklist>
* <https://github.com/unixorn/awesome-zsh-plugins>
* <https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html>
* <https://github.com/iCHAIT/awesome-macOS>
