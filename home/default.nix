# Home-manager entry point.
# This file imports all the per-module configs and sets base home-manager options.
# Each module is self-contained — you can comment out any import to disable it.
#
# Noctalia Shell provides the bar, dock, launcher, and notifications
# as a single integrated shell, so waybar.nix / rofi.nix / dock.nix /
# notifications.nix are no longer imported. They're kept in the repo
# in case you ever want to switch back to standalone tools.

{ config, pkgs, ... }:

{
  imports = [
    ./hyprland.nix       # Hyprland compositor settings
    ./noctalia.nix       # Desktop shell (bar, dock, launcher, notifications, OSD)
    ./terminal.nix       # Kitty terminal emulator
    ./shell.nix          # Zsh + Starship prompt
    ./theme.nix          # GTK theme, fonts, cursors, colors
    ./screenshot.nix     # Screenshot tools (grim + slurp)
    # --- Replaced by Noctalia ---
    # ./waybar.nix       # (Noctalia has a built-in top bar)
    # ./rofi.nix         # (Noctalia has a built-in app launcher)
    # ./dock.nix         # (Noctalia has a built-in dock)
    # ./notifications.nix # (Noctalia has a built-in notification center)
  ];

  # ---------- Home-manager basics ----------
  home.username = "user";
  home.homeDirectory = "/home/user";

  # This should match the NixOS stateVersion in configuration.nix.
  # It tells home-manager which defaults to use. Don't change it
  # after initial setup unless you're migrating.
  home.stateVersion = "24.11";

  # Let home-manager manage itself (needed for the `home-manager` CLI)
  programs.home-manager.enable = true;
}
