#!/bin/zsh

sudo -v

# Disable the startup chime on boot
sudo nvram StartupMute=%01

# Trackpad tracking speed
defaults write -g com.apple.trackpad.scaling -float 1.5

# Tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

# Dragging with three finger drag 
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -bool false
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -bool false

# Set a fast keyboard repeat rate, and make it happen more quickly.
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 2

# Change default location for screenshots
mkdir -p $HOME/screenshots
defaults write com.apple.screencapture location -string "$HOME/screenshots"

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Don't show recent tags
defaults write com.apple.finder ShowRecentTags -bool false

# Set home as the default location for new Finder windows
defaults write com.apple.finder NewWindowTarget -string "PfVo"

# Don't show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

# Show all filename extensions
defaults write -g AppleShowAllExtensions -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Show path bar in the bottom of the Finder windows
defaults write com.apple.finder ShowPathbar -bool true

# Show status bar in the bottom of the Finder windows
defaults write com.apple.finder ShowStatusBar -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Use column view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Show the ~/Library folder
chflags nohidden ~/Library && xattr -d com.apple.FinderInfo ~/Library 2>/dev/null

# Show the /Volumes folder
sudo chflags nohidden /Volumes

# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# Autohide the Dock when the mouse is out
defaults write com.apple.dock "autohide" -bool true

# Remove the Dock autohide animation
defaults write com.apple.dock "autohide-time-modifier" -float "0"

# Remove the autohide delay, the Dock appears instantly
defaults write com.apple.dock "autohide-delay" -float "0"

# Change minimize/maximize window effect
defaults write com.apple.dock mineffect -string "scale"

# Don’t animate opening applications from the Dock
defaults write com.apple.dock launchanim -bool false

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Don’t show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

# Remove all apps from Dock
defaults write com.apple.dock persistent-apps -array

# Photos: Prevent from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

# Time Machine: Prevent prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Disable automatic capitalization as it’s annoying when typing code
defaults write -g NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic period substitution as it’s annoying when typing code
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart quotes as they’re annoying when typing code
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable autocorrect
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false

killall Dock