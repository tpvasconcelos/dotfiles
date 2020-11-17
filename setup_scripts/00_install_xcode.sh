#!/usr/bin/env bash

# Install and update Xcode and command-line tools  ---

# Download Xcode from the App Store
# mas install 497799835

# FIXME: is this still needed?
# sudo rm -rf /Library/Developer/CommandLineTools

# Make sure `xcode-select` is pointing to the correct delevoper directory
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer

# Install Xcode
xcode-select --install

# Accept Xcode's Licence
sudo sudo xcodebuild -license accept

# Simulate lauching Xcode once
sudo xcodebuild -runFirstLaunch

# Update everything and restart the computer
printf "The computer will restart after running softwareupdate. Press ENTER to continue...\n"
read -r
sudo softwareupdate --force --install --all --verbose --restart