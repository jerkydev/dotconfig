#!/usr/bin/env bash
set -e

systemctl --user enable --now hyprpolkitagent
systemctl --user enable --now pipewire-pulse
systemctl --user enable --now gnome-keyring-daemon
sudo systemctl enable bluetooth
sudo systemctl enable ly@tty2
sudo systemctl enable docker
sudo usermod -aG docker $USER
systemctl enable --now upower power-profiles-daemon
# systemctl enable --now nix-daemon

