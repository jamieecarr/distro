# Dock configuration — macOS-style application dock using nwg-dock-hyprland.
# nwg-dock-hyprland is a dock built specifically for Hyprland. It shows
# pinned app launchers and running application indicators, similar to
# the macOS Dock.
#
# It auto-hides by default and appears when you move the mouse to the
# bottom edge of the screen.

{ config, pkgs, ... }:

{
  # Install the dock package
  home.packages = with pkgs; [
    nwg-dock-hyprland
  ];

  # ---------- Dock launcher script ----------
  # nwg-dock-hyprland is configured via command-line flags.
  # We create a wrapper script so the autostart line stays clean
  # and you can tweak settings in one place.
  #
  # Key flags:
  #   -d          : auto-hide the dock (show on hover at bottom edge)
  #   -i 48       : icon size in pixels
  #   -l "apps"   : pinned app list (launcher .desktop names, space-separated)
  #   -mb 6       : margin from bottom edge (px)
  #   -hd 0       : hide delay in ms (0 = instant)
  #   -nolauncher : don't show the grid launcher button (we have rofi)
  xdg.configFile."nwg-dock-hyprland/style.css" = {
    text = ''
      /* Dock container — translucent background with rounded corners */
      window {
        background: rgba(30, 30, 46, 0.8);
        border-radius: 16px;
        border: 1px solid rgba(69, 71, 90, 0.5);
        padding: 4px 8px;
      }

      /* Individual dock icons */
      button {
        background: transparent;
        border: none;
        border-radius: 10px;
        padding: 4px;
        margin: 2px;
      }

      /* Hover effect on dock icons */
      button:hover {
        background: rgba(137, 180, 250, 0.2);
      }
    '';
  };
}
