# Stop iTunes from opening when iPhone is connected
defaults write com.apple.iTunesHelper ignore-devices 1
# Stop Photos from opening when iPhone is connected
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

# safe sleep
# https://www.lifewire.com/change-mac-sleep-settings-2260804
sudo pmset -a hibernatemode 3

# disable the Sudden Motion Sensor
sudo pmset -a sms 0

# Change standby time. Larger values make waking up from sleep faster. Lower values save more batery.
# https://www.cultofmac.com/221392/quick-hack-speeds-up-retina-macbooks-wake-from-sleep-os-x-tips/
# sudo pmset -a standbydelay 86400

# Save to disk, rather than iCloud, by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Check for software updates daily
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Turn off keyboard illumination when computer is not used for 1 minute
defaults write com.apple.BezelServices kDimTime -int 60

# Disable display from automatically adjusting brightness
sudo defaults write /Library/Preferences/com.apple.iokit.AmbientLightSensor "Automatic Display Enabled" -bool false

# Disable keyboard from automatically adjusting backlight brightness in low light
sudo defaults write /Library/Preferences/com.apple.iokit.AmbientLightSensor "Automatic Keyboard Enabled" -bool false

# Requiring password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Enabling subpixel font rendering on non-Apple LCDs
defaults write NSGlobalDomain AppleFontSmoothing -int 1

# Save screenshots as PNG
defaults write com.apple.screencapture type -string "png"

# --- trackpad
# Tracking speed
defaults write -g com.apple.trackpad.scaling 2.5
defaults write -g com.apple.mouse.scaling 3

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 20
