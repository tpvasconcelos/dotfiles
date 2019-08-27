# Stop iTunes from opening when iPhone is connected
defaults write com.apple.iTunesHelper ignore-devices 1
# Stop Photos from opening when iPhone is connected
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool YES

