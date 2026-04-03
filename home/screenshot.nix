# Screenshot tools — grim + slurp + wl-clipboard.
# This provides macOS-like screenshot capabilities on Wayland:
#
#   Print        → capture entire screen (like macOS Cmd+Shift+3)
#   SUPER+SHIFT+S → select a region to capture (like macOS Cmd+Shift+4)
#
# Screenshots are saved to ~/Pictures/Screenshots/ and also copied
# to the clipboard so you can paste them immediately.
#
# Tools:
#   grim   — takes the actual screenshot (Wayland-native)
#   slurp  — lets you draw a selection rectangle on screen
#   wl-clipboard — copies the screenshot to the Wayland clipboard

{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    grim          # Screenshot capture tool for Wayland
    slurp         # Region selection tool (draw a rectangle to capture)
    wl-clipboard  # Clipboard manager (wl-copy / wl-paste)
  ];

  # Ensure the screenshots directory exists
  home.file."Pictures/Screenshots/.keep".text = "";
}
