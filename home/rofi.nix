# Rofi app launcher — configured to feel like macOS Spotlight.
# Uses rofi-wayland (the Wayland-native fork of rofi).
# Triggered with SUPER+Space (see hyprland.nix keybinds).

{ config, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;  # Wayland fork — required for Hyprland

    # ---------- Basic settings ----------
    terminal = "kitty";

    extraConfig = {
      # Show desktop application entries (the .desktop files)
      modi = "drun";
      show-icons = true;
      icon-theme = "Papirus-Dark";

      # Spotlight-like behavior: single search bar, centered
      display-drun = "";           # No label on the search bar
      drun-display-format = "{name}";  # Show just the app name

      # Positioning — centered on screen
      location = 0;               # 0 = center
      width = 500;
    };

    # ---------- Theme ----------
    # Custom CSS-like theme for a Spotlight-inspired look:
    # translucent background, rounded corners, single search bar.
    theme =
      let
        # Rofi theme uses a special syntax. mkLiteral passes values through
        # without quoting (needed for colors and dimensions).
        inherit (config.lib.formats.rasi) mkLiteral;
      in
      {
        "*" = {
          bg = mkLiteral "rgba(26, 27, 38, 0.85)";
          fg = mkLiteral "#c0caf5";
          accent = mkLiteral "#7aa2f7";
          border-color = mkLiteral "rgba(65, 72, 104, 0.5)";
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@fg";
          font = "Inter 14";
        };

        window = {
          background-color = mkLiteral "@bg";
          border = mkLiteral "1px";
          border-color = mkLiteral "@border-color";
          border-radius = mkLiteral "16px";
          padding = mkLiteral "20px";
          width = mkLiteral "500px";
        };

        inputbar = {
          padding = mkLiteral "10px 16px";
          background-color = mkLiteral "rgba(36, 40, 59, 0.9)";
          border-radius = mkLiteral "12px";
          children = map mkLiteral [ "entry" ];
        };

        entry = {
          placeholder = "Search...";
          placeholder-color = mkLiteral "rgba(192, 202, 245, 0.4)";
        };

        listview = {
          lines = 6;              # Show 6 results at a time
          columns = 1;
          spacing = mkLiteral "4px";
          padding = mkLiteral "10px 0 0 0";
          fixed-height = false;
        };

        element = {
          padding = mkLiteral "8px 12px";
          border-radius = mkLiteral "8px";
        };

        "element selected" = {
          background-color = mkLiteral "rgba(137, 180, 250, 0.2)";
          text-color = mkLiteral "@accent";
        };

        element-text = {
          vertical-align = mkLiteral "0.5";
        };

        element-icon = {
          size = mkLiteral "24px";
          margin = mkLiteral "0 10px 0 0";
        };
      };
  };
}
