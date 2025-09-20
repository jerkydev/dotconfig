# Configs
My working environment configs

## First Install

1. Install homebrew
1. ```
   git clone https://github.com/jerkydev/dotconfig.git .dotconfig
   cd .dotconfig
   git submodule update --init --recursive
   brew install stow
   stow .
   brew bundle
   ./scripts/tweak_macos.sh
   ```
1. Reboot

