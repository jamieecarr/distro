# Notification center — SwayNotificationCenter (swaync).
# swaync provides both popup notifications AND a pull-down sidebar
# panel similar to the macOS Notification Center.
#
# Toggle the sidebar with SUPER+N (keybind added in hyprland.nix).
# Notifications pop up in the top-right corner by default.

{ config, pkgs, ... }:

{
  # Install swaync
  home.packages = with pkgs; [
    swaynotificationcenter
  ];

  # ---------- swaync config ----------
  # Controls notification behavior (position, timeout, grouping).
  xdg.configFile."swaync/config.json" = {
    text = builtins.toJSON {
      # Position notifications in the top-right (like macOS)
      positionX = "right";
      positionY = "top";

      # How long notifications stay on screen (ms)
      timeout = 5000;
      timeout-low = 3000;
      timeout-critical = 0;  # Critical notifications stay until dismissed

      # Notification popup count before they start stacking
      notification-window-width = 360;

      # Number of notifications visible at once
      max-notifications = 5;

      # Sidebar panel settings (the Notification Center)
      control-center-width = 380;
      control-center-height = 600;
      control-center-margin-top = 8;
      control-center-margin-right = 8;

      # Group notifications from the same app
      notification-2d-threshold = 0;

      # Show notification body text
      hide-on-clear = false;
      hide-on-action = true;

      # Widgets shown in the notification center sidebar
      widgets = [
        "title"
        "notifications"
      ];
    };
  };

  # ---------- swaync styling ----------
  # CSS theme to match the rest of the desktop (translucent, rounded, Tokyo Night).
  xdg.configFile."swaync/style.css" = {
    text = ''
      /* Global styling */
      * {
        font-family: "Inter", sans-serif;
        font-size: 13px;
      }

      /* Individual notification popups */
      .notification {
        background: rgba(30, 30, 46, 0.9);
        border: 1px solid rgba(69, 71, 90, 0.5);
        border-radius: 12px;
        padding: 8px;
        margin: 4px;
        color: #c0caf5;
      }

      /* Notification title */
      .notification .summary {
        font-weight: bold;
        color: #c0caf5;
      }

      /* Notification body text */
      .notification .body {
        color: #a9b1d6;
      }

      /* Close button on notifications */
      .notification .close-button {
        background: rgba(137, 180, 250, 0.2);
        border-radius: 8px;
        color: #c0caf5;
        border: none;
        padding: 2px 8px;
      }

      /* The notification center sidebar panel */
      .control-center {
        background: rgba(26, 27, 38, 0.92);
        border: 1px solid rgba(69, 71, 90, 0.5);
        border-radius: 16px;
        padding: 12px;
        color: #c0caf5;
      }

      /* Title bar in the notification center */
      .control-center .widget-title {
        font-size: 16px;
        font-weight: bold;
        margin-bottom: 8px;
        color: #c0caf5;
      }

      /* Clear all button */
      .control-center .clear-all {
        background: rgba(137, 180, 250, 0.15);
        border-radius: 8px;
        border: none;
        color: #7aa2f7;
        padding: 4px 12px;
      }

      .control-center .clear-all:hover {
        background: rgba(137, 180, 250, 0.3);
      }
    '';
  };
}
