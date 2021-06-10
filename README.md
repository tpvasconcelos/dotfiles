# My dotfiles

These are my personal [dotfiles](https://wiki.archlinux.org/index.php/Dotfiles). This repository helps me keep a
reproducible version of my development environment, configuration files, system preferences, and even my desktop
applications.

I keep a step-by-step guide in this README on how to get from a fresh macOS installation to a fully-setup working and
development environment. From setting up my zsh shell and various CLI tools, to installing my desktop apps, to migrating
configuration files and updating the default macOS preferences... these steps are all automated (and reproducible)
through shell scripts.

## Table of Contents

- [Fresh macOS Install (a step-by-step guide)](#fresh-macos-install-a-step-by-step-guide)
    - [Clone this repository](#clone-this-repository)
    - [Setup development environment](#setup-development-environment)
    - [Update general macOS preferences](#update-general-macos-preferences)
    - [Install desktop applications](#install-desktop-applications)
    - [Update everything](#update-everything)
    - [Check for issues](#check-for-issues)
- [References](#references)

## Fresh macOS Install (a step-by-step guide)

In order to follow the following guide, you will need to have admin access to your macOS machine and you will also need
to be logged in with your Apple ID (check both System Preferences and the App Store for this).

### Clone this repository

Clone this repository under `~/.dotfiles`

```shell script
git clone https://github.com/tpvasconcelos/dotfiles.git ~/.dotfiles && \
  cd ~/.dotfiles
```

#### Unlock the repository

Install dependencies for this step

```shell script
brew install git git-crypt gpg
```

Copy you GnuPG secret key to a temporaty `path/to/secret.key` file and load it onto this machine.

```shell script
gpg --allow-secret-key-import --import path/to/secret.key
```

Unlock the repo using the imported GnuPG key.

```shell script
git-crypt unlock
```

**Note:** here's how you can save an existing GnuPG key:

```shell script
gpg --export --armor $GPG_KEY_ID > path/to/public.key
gpg --export-secret-keys --armor $GPG_KEY_ID > path/to/secret.key
```

### Setup development environment

#### Install Xcode and Command Line Developer Tools

**[UPDATE] -** Since macOS Big Sur, the Command Line Developer Tools are installed once the `git` command is invoked (
used above). Therefore, the next steps might be unnecessary.

1. Start by downloading Xcode from the App Store. Once this download is complete, run the following shell commands from
   the Terminal app.
1. Here, we will install the Command Line Developer Tools. The first command ensures `xcode-select` is pointing to the
   correct (active) developer directory. Follow the installation steps that will open in a user interface dialog and
   proceed to the next step.
    ```shell script
    sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
    xcode-select --install
    ```
1. As a final step, you'll need to accept the Xcode and SDK license agreements. The second command will also install any
   missing packages.
    ```shell script
    sudo xcodebuild -license accept
    sudo xcodebuild -runFirstLaunch
    ```

##### Install any pending software updates

We'll now install any pending software updates for your machine. **Note that, if needed, this command will automatically
restart your machine!**

```shell script
sudo softwareupdate --install --all --verbose --force --agree-to-license --restart
```

#### Install Homebrew (brew)

From here on out we will use [Homebrew](https://brew.sh) (`brew`) as the go-to package manager for macOS.

```shell script
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew update && brew upgrade
```

#### Upgrade and configure shells

This script will install and configure more up-tp-date versions of the bash and zsh shells. Run this in the terminal
emulator installed in the previous step (e.g. Iterm2).

```shell script
./setup_scripts/setup_shells.zsh
```

Here I'm using a bare [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh/) configuration with a
[powerlevel10k](https://github.com/romkatv/powerlevel10k) theme. You can consider other frameworks, such as:

- [prezto](https://github.com/sorin-ionescu/prezto) - The configuration framework for Zsh
- [zinit](https://github.com/zdharma/zinit) - Ultra-flexible and fast Zsh plugin manager with clean fpath, reports,
  completion management, Turbo, annexes, services, packages.
- [zplug](https://github.com/zplug/zplug) - 🌺 A next-generation plugin manager for zsh
- [antibody](https://github.com/getantibody/antibody) - The fastest shell plugin manager.

#### Install CLI and dev tools

Have a look inside this script to see what will be installed...

```shell script
./setup_scripts/cli_and_dev_tools.zsh
```

#### Shell Startup Files

Create symlinks to your startup scripts. **Warning: this will overwrite any existing files under the same path.**

```shell script
ln -shfv "$(realpath .zshenv)" ~
ln -shfv "$(realpath .zshrc)" ~
```

The rules that define whether a startup script is sourced (and in which order) differ depending on the UNIX shell,
initialization strategy, and even operating system. To keep things simple, we'll focus only on the zsh shell on a macOS
system. So here are some simple examples.

- When opening a new terminal shell on a terminal emulator such as iTerm2 or Terminal, the following files get
  sourced: `.zshenv --> .zprofile --> .zshrc --> .zlogin`. You are now using an _interactive login shell_. Once you kill
  the current shell, the `.zlogout` script will be sourced before killing the process.
- If you source a script (e.g. `source some_script` or `. ./some_script`), no startup files get sourced. This is
  because `source` reads and executes the contents of your script _within_ the **current shell**
  environment.
- If you run a script as an executable (e.g. `./some_script`), the script will run in an **new shell**. By default, and
  in most cases, this will be a non-interactive non-login shell and, therefore, will only source
  `.zshenv` before executing the script. You can extend this logic _ad infinitum_... if script calls yet another script,
  which in turn calls yet again another script, etc, etc... each one will run in a new shell. Here I'm assuming that the
  script will be executed within a zsh shell of course! If script contains a
  `#!/usr/bin/env zsh` shebang line, it can be executed directly as `./some_script` or called as a regular command if it
  exists under `$PATH`. Alternatively you can explicitly execute the script as
  `zsh some_script`.

#### Install Python Development Tools

I use [pyenv](https://github.com/pyenv/pyenv) to manage my python versions. Then
[pipenv](https://github.com/pypa/pipenv) and [poetry](https://github.com/python-poetry/poetry) to manage virtual
environments. The following script will install your whole python development environment. To check which python
versions will be installed run `echo "$PYENV_TARGET_VERSIONS`. You can pass either the exact patch version, or the minor
version (in which case the latest patch will be installed).

- Install with the default versions `"$PYENV_TARGET_VERSIONS`
    ```shell script
    ./setup_scripts/python_dev_environment.zsh
    ```
- Pass your own versions
    ```shell script
    PYENV_TARGET_VERSIONS_OVERWRITE="3.7 3.8.5" ./setup_scripts/python_dev_environment.zsh
    ```

#### Setup `ssh` for `git`

For a more detailed guide, look at the official documentation from
[GitHub](https://help.github.com/en/articles/connecting-to-github-with-ssh),
[Bitbucket](https://confluence.atlassian.com/bitbucket/set-up-an-ssh-key-728138079.html#SetupanSSHkey-ssh2),
and [GitLab](https://docs.gitlab.com/ee/ssh/). However, if you are just looking for a reminder, use the snipped bellow

```shell script
yes | ssh-keygen -P "" -f ~/.ssh/id_rsa
eval "$(ssh-agent)"
/usr/bin/ssh-add -K ~/.ssh/id_rsa

# Here, we are copying the public key to the clipboard.
# After running this, add it to your GitHub/GitLab/Bitbucket known SSH keys!
pbcopy < ~/.ssh/id_rsa.pub
```

### Update general macOS preferences

This will update many of the default macos settings and system preferences. **Warning: It's recommended to reboot your
machine after updating many of these preferences.** For convenience, this script will prompt you for an automatic reboot
at the end 💪

```shell script
./setup_scripts/macos.zsh
```

From the [macOS User Guide](https://support.apple.com/en-gb/guide/mac-help/mh35890/mac), you have the option to add a
message on the Mac login window. It can be used _"to provide contact information for a misplaced computer."_

```shell script
sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "If lost, please contact your_email_here@example.com"
```

### Install desktop applications

Have a look inside this script to see what will be installed...

```shell script
./setup_scripts/desktop_apps.zsh
```

#### Migrate app settings and system preferences

App settings:

1. Migrate all relevant config directories from `~/Library/Application\ Support`
2. Migrate all relevant app preferences from `~/Library/Preferences/`

### Update everything

**Note that, if needed, the first command will automatically restart your machine!**

```shell script
sudo softwareupdate --install --all --verbose --force --restart
```

Update any packages installed with brew

```shell script
brew update
brew upgrade
brew upgrade --cask --greedy
brew cleanup
```

### Check for issues

Run `brew doctor` to check for any hanging issues

```shell script
brew doctor
```

### Reclaim some disk space

Safely delete some `CoreSimulator` caches used by Xcode

```shell script
xcrun simctl delete all && xcrun simctl erase all
rm -rf ~/Library/Developer/CoreSimulator/Caches/*
```

You can occasionally also clear your caches for tools like Homebrew and `pip`

```shell script
# clear homebrew's caches
brew cleanup -s

# Clears caches (pipenv, pip, and pip-tools)
pipenv --clear

# Prune docker
docker container prune
docker image prune
```

## Todo

[] Create Zsh functions

- [lukeojones - 1UP your Zsh abilities by autoloading your own functions](https://dev.to/lukeojones/1up-your-zsh-abilities-by-autoloading-your-own-functions-2ngp)
- [An Introduction to the Z Shell - Shell Functions](http://zsh.sourceforge.net/Intro/intro_4.html)
- [The Z Shell Manual - Functions](http://zsh.sourceforge.net/Doc/Release/Functions.html)

## References

* [The "Hacker News Comment" Method](https://news.ycombinator.com/item?id=11070797) - This Hacker News comment
  popularised the "bare repository and alias method" for managing dotfiles. This method is also references in
  [Dotfiles (ArchWiki)](https://wiki.archlinux.org/index.php/Dotfiles).
* [Awesome macOS Command Line](https://github.com/herrbischoff/awesome-macos-command-line) - inspiration for most of the
  settings in [macos.zsh](macos.zsh). Take everything in this repository with a pinch of salt. macOS is a fast-moving
  environment that does not prioritise backwards compatibility for these settings or preferences.
* [A User's Guide to the Z-Shell - What to put in your startup files](http://zsh.sourceforge.net/Guide/zshguide02.html)
* <https://github.com/grant/new-computer-checklist>
* <https://github.com/unixorn/awesome-zsh-plugins>
* <https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html>
* <https://github.com/iCHAIT/awesome-macOS>
* [A collection of useful .gitignore templates](https://github.com/github/gitignore)
* [Shell startup scripts](https://blog.flowblok.id.au/2013-02/shell-startup-scripts.html) - An article about
  standardizing shell startup scripts.
