# Configs
My working environment configs and install scripts. macOS and zsh specific. Tested in Monterey (early 2023).

## Install

1. Clone configs:
    ```
    git clone https://github.com/vyalovvldmr/configs.git /Users/$USER/.config
    ```
1. Install Homebrew:
    ```
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```
1. The following command automates a fresh install of:
    - Sublime Text
    - zsh-autosuggestions
    - Meslo Nerd font
    - Alacritty terminal
    - Zellij
    - Starship
    - Docker
    - Firefox Developer edition
    - KeePassXC
    - neovim
    - htop
    - pyenv

    using homebrew
    ```
    make install
    ```
1. Init git config:
    ```
    make init
    ```
