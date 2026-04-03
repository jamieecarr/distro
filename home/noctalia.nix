# Noctalia Shell — unified desktop shell for Wayland.
#
# Noctalia replaces several standalone tools with a single integrated shell:
#   - Top bar (replaces Waybar)
#   - App launcher (replaces Rofi)
#   - Notification center (replaces swaync / dunst)
#   - Dock (replaces nwg-dock-hyprland / plank)
#   - Lock screen (replaces swaylock)
#   - OSD for volume/brightness (replaces standalone OSD tools)
#
# It's built on Quickshell (Qt/QML) and designed for Wayland compositors
# like Hyprland. The "noctalia" flake input is passed via specialArgs
# from flake.nix.

{ config, pkgs, noctalia, ... }:

{
  # Import the Noctalia home-manager module from the flake
  imports = [
    noctalia.homeModules.default
  ];

  # ---------- Enable Noctalia ----------
  programs.noctalia-shell = {
    enable = true;

    # ---------- Noctalia settings ----------
    # These map to Noctalia's internal config. Customize to taste.
    # Run `qs -c noctalia-shell ipc show` at runtime to discover
    # all available IPC commands.
    settings = {
      # Bar position and style
      bar = {
        position = "top";   # Top bar like macOS
      };

      # General appearance
      general = {
        radius = 10;        # Corner rounding on panels and popups
      };

      # UI font settings — use the same fonts as the rest of the desktop
      ui = {
        font = "Inter";
      };
    };
  };
}
