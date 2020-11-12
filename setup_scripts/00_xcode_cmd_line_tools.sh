#!/usr/bin/env bash

# Install and update Xcode and command-line tools  ---

mas install 497799835

sudo rm -rf /Library/Developer/CommandLineTools
xcode-select --install  # this didnt work last time! dont know why...
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer

sudo sudo xcodebuild -license accept
sudo xcodebuild -runFirstLaunch

printf "The computer will restart after running softwareupdate. \nPress ENTER to continue..."
read

sudo softwareupdate --force --install --all --verbose --restart