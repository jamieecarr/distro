# Kitty terminal emulator configuration.
# Kitty is a fast, GPU-accelerated terminal with good font rendering.

{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;

    settings = {
      # ---------- Font ----------
      font_family = "JetBrainsMono Nerd Font";
      font_size = 13;

      # ---------- Window appearance ----------
      background_opacity = "0.95";        # Slight transparency
      window_padding_width = 10;          # Padding inside the terminal (px)
      confirm_os_window_close = 0;        # Don't ask "are you sure?" on close

      # ---------- Scrollback ----------
      scrollback_lines = 10000;

      # ---------- Bell ----------
      enable_audio_bell = "no";           # No beeping

      # ---------- macOS-like cursor ----------
      cursor_shape = "beam";              # Thin cursor like a text editor

      # ---------- Color scheme ----------
      # A clean, neutral palette inspired by Tokyo Night.
      # Background and foreground
      foreground = "#c0caf5";
      background = "#1a1b26";

      # Black
      color0  = "#15161e";
      color8  = "#414868";

      # Red
      color1  = "#f7768e";
      color9  = "#f7768e";

      # Green
      color2  = "#9ece6a";
      color10 = "#9ece6a";

      # Yellow
      color3  = "#e0af68";
      color11 = "#e0af68";

      # Blue
      color4  = "#7aa2f7";
      color12 = "#7aa2f7";

      # Magenta
      color5  = "#bb9af7";
      color13 = "#bb9af7";

      # Cyan
      color6  = "#7dcfff";
      color14 = "#7dcfff";

      # White
      color7  = "#a9b1d6";
      color15 = "#c0caf5";
    };
  };
}
