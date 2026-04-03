# Theme configuration — GTK theme, icons, cursor, fonts, and color palette.
# This file centralizes the visual identity. Other modules reference
# the colors defined here where possible.

{ config, pkgs, ... }:

let
  # ---------- Shared color palette ----------
  # Tokyo Night inspired — neutral, clean, macOS-like.
  # Reference these variables in other modules for consistency.
  colors = {
    bg        = "#1a1b26";    # Main background
    bg-dark   = "#15161e";    # Darker background (panels, sidebars)
    bg-light  = "#24283b";    # Lighter background (active elements)
    fg        = "#c0caf5";    # Main text color
    fg-dim    = "#a9b1d6";    # Dimmed text
    border    = "#414868";    # Borders and separators
    blue      = "#7aa2f7";    # Primary accent
    purple    = "#bb9af7";    # Secondary accent
    green     = "#9ece6a";    # Success
    red       = "#f7768e";    # Error / destructive
    yellow    = "#e0af68";    # Warning
    cyan      = "#7dcfff";    # Info
    orange    = "#ff9e64";    # Attention
  };
in
{
  # ---------- GTK theme ----------
  # adw-gtk3 gives a clean, modern look similar to macOS's Aqua.
  gtk = {
    enable = true;

    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
    };

    # GTK font configuration
    font = {
      name = "Inter";
      size = 11;
    };
  };

  # ---------- Cursor theme (Wayland) ----------
  # GTK cursor config only affects GTK apps. This sets it for all Wayland apps.
  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;  # Also apply to GTK
  };

  # ---------- Fonts ----------
  # Install the fonts used across the desktop.
  home.packages = with pkgs; [
    inter                         # UI font — clean sans-serif
    nerd-fonts.jetbrains-mono     # Monospace font with icons (terminal, editor)
    noto-fonts                    # Fallback for broad Unicode coverage
    noto-fonts-emoji              # Emoji support
  ];

  # ---------- Environment variables ----------
  # These ensure consistent theming across different toolkit apps.
  home.sessionVariables = {
    # Tell Qt apps to use the GTK theme (avoids mismatched styling)
    QT_QPA_PLATFORMTHEME = "gtk3";

    # Set the cursor theme for apps that read this variable
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
  };
}
