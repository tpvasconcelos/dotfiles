#!/usr/bin/env bash

function add_app_to_dock() {
  # adds an application to macOS Dock
  # example add_app_to_dock "Terminal"
  app_name="${1}"
  launchservices_path="/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister"
  app_path=$(${launchservices_path} -dump | grep -o "/.*${app_name}.app" | grep -v -E "Backups|Caches|TimeMachine|Temporary|/Volumes/${app_name}" | uniq | sort | head -n1)
  if open -Ra "${app_path}"; then
    defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>${app_path}</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
    echo "$app_name added to the Dock."
  else
    echo "ERROR: $app_name not found."
  fi
}

function add_folder_to_dock() {
  # adds a folder to macOS Dock
  # usage: add_folder_to_dock "Folder Path" -s n -d n -v n
  # example: add_folder_to_dock "~/Downloads" -d 0 -s 2 -v 1
  # key:
  # -s or --sortby
  # 1 -> Name
  # 2 -> Date Added
  # 3 -> Date Modified
  # 4 -> Date Created
  # 5 -> Kind
  # -d or --displayas
  # 0 -> Stack
  # 1 -> Folder
  # -v or --viewcontentas
  # 0 -> Automatic
  # 1 -> Fan
  # 2 -> Grid
  # 3 -> List
  folder_path="${1}"
  sortby="1"
  displayas="0"
  viewcontentas="0"
  while [[ "$#" -gt 0 ]]; do
    case $1 in
    -s | --sortby)
      if [[ $2 =~ ^[1-5]$ ]]; then
        sortby="${2}"
      fi
      ;;
    -d | --displayas)
      if [[ $2 =~ ^[0-1]$ ]]; then
        displayas="${2}"
      fi
      ;;
    -v | --viewcontentas)
      if [[ $2 =~ ^[0-3]$ ]]; then
        viewcontentas="${2}"
      fi
      ;;
    esac
    shift
  done

  if [ -d "$folder_path" ]; then
    echo "$folder_path added to the Dock."
    defaults write com.apple.dock persistent-others -array-add "<dict>
              <key>tile-data</key> <dict>
                  <key>arrangement</key> <integer>${sortby}</integer>
                  <key>displayas</key> <integer>${displayas}</integer>
                  <key>file-data</key> <dict>
                      <key>_CFURLString</key> <string>file://${folder_path}</string>
                      <key>_CFURLStringType</key> <integer>15</integer>
                  </dict>
                  <key>file-type</key> <integer>2</integer>
                  <key>showas</key> <integer>${viewcontentas}</integer>
              </dict>
              <key>tile-type</key> <string>directory-tile</string>
          </dict>"
  else
    echo "ERROR: $folder_path not found."
  fi
}

function add_spacer_to_dock() {
  # adds an empty space to macOS Dock
  defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="small-spacer-tile";}'
}

function clear_dock() {
  # removes all persistent icons from macOS Dock
  defaults write com.apple.dock persistent-apps -array
}

function reset_dock() {
  # reset macOS Dock to default settings
  defaults write com.apple.dock
  killall Dock
}

# WARNING: permanently clears existing dock
clear_dock

add_app_to_dock "Mail"
add_app_to_dock "WhatsApp"
add_app_to_dock "Slack"
#add_spacer_to_dock
add_app_to_dock "Tor Browser"
add_app_to_dock "Firefox"
add_app_to_dock "Google Chrome"
add_app_to_dock "Safari"
#add_spacer_to_dock
add_app_to_dock "Spotify"
add_app_to_dock "Vuze"
add_app_to_dock "Popcorn-Time"
add_app_to_dock "Streamio"
add_app_to_dock "VLC"
#add_spacer_to_dock
add_app_to_dock "Photos"
add_app_to_dock "Adobe Photoshop CC 2018"
add_app_to_dock "Adobe Lighroom Classic CC"
add_app_to_dock "Affinity Photo"
add_app_to_dock "Affinity Designer"
add_app_to_dock "blender"
#add_spacer_to_dock
add_app_to_dock "Stickies"
add_app_to_dock "Calendar"
add_app_to_dock "Microsoft OneNote"
add_app_to_dock "Skitch"
add_app_to_dock "Preview"
add_app_to_dock "Notability"
add_app_to_dock "Texpad"
add_app_to_dock "TextMate"
#add_spacer_to_dock
add_app_to_dock "Mathematica"
add_app_to_dock "RStudio"
add_app_to_dock "Visual Studio Code"
add_app_to_dock "PyCharm"
add_app_to_dock "WebStorm"
add_app_to_dock "DataGrip"
add_app_to_dock "File Viewer"
add_app_to_dock "iTerm"
#add_spacer_to_dock
add_app_to_dock "Activity Monitor"
add_app_to_dock "Disk Utility"
add_app_to_dock "System Preferences"

killall Dock
