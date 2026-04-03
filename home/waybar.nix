# Waybar configuration — a macOS-style top bar for Hyprland.
# Waybar displays workspace indicators, clock, system tray, and status info.

{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;

    # ---------- Bar layout and modules ----------
    settings = {
      mainBar = {
        layer = "top";      # Render above windows
        position = "top";
        height = 36;
        margin-top = 5;     # Gap from top edge of screen
        margin-left = 10;   # Gap from left edge
        margin-right = 10;  # Gap from right edge

        # Which modules appear in each section of the bar
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [
          "network"
          "bluetooth"
          "battery"
          "pulseaudio"
          "tray"
        ];

        # ---------- Module configs ----------

        # Workspace indicators — clickable buttons for each workspace
        "hyprland/workspaces" = {
          format = "{id}";               # Just show the workspace number
          on-click = "activate";          # Click to switch
          sort-by-number = true;
        };

        # Clock — macOS-style format: "Thu Apr  3  2:45 PM"
        clock = {
          format = "{:%a %b %e  %l:%M %p}";
          tooltip-format = "{:%A, %B %e, %Y}";  # Full date on hover
        };

        # Network — shows WiFi SSID or "Disconnected"
        network = {
          format-wifi = "{essid} ";       #  = WiFi icon (nerd font)
          format-ethernet = "Wired 󰈀";
          format-disconnected = "No Network 󰖪";
          tooltip-format = "{ipaddr}";
        };

        # Bluetooth
        bluetooth = {
          format = "󰂯";                   # Bluetooth icon
          format-disabled = "󰂲";          # Disabled icon
          tooltip-format = "{status}";
        };

        # Battery — shows percentage and charging icon
        battery = {
          format = "{capacity}% {icon}";
          format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          format-charging = "{capacity}% 󰂄";
          states = {
            warning = 20;
            critical = 10;
          };
        };

        # Volume — click to open pavucontrol
        pulseaudio = {
          format = "{volume}% {icon}";
          format-muted = "Muted 󰖁";
          format-icons.default = [ "󰕿" "󰖀" "󰕾" ];
          on-click = "pavucontrol";
        };

        # System tray — shows icons for background apps (nm-applet, etc.)
        tray = {
          spacing = 8;
        };
      };
    };

    # ---------- Styling (CSS) ----------
    # This CSS gives the bar a translucent, rounded, macOS-inspired look.
    style = ''
      /* Global font — clean sans-serif */
      * {
        font-family: "Inter", "Noto Sans", sans-serif;
        font-size: 13px;
        color: #cdd6f4;
      }

      /* The bar itself — translucent dark background with rounded corners */
      window#waybar {
        background: rgba(30, 30, 46, 0.85);
        border-radius: 12px;
        border: 1px solid rgba(69, 71, 90, 0.5);
      }

      /* Remove default button styling */
      button {
        border: none;
        border-radius: 0;
      }

      /* Workspace buttons */
      #workspaces button {
        padding: 0 8px;
        margin: 4px 2px;
        border-radius: 8px;
        background: transparent;
      }

      #workspaces button.active {
        background: rgba(137, 180, 250, 0.3);
        color: #89b4fa;
      }

      #workspaces button:hover {
        background: rgba(137, 180, 250, 0.15);
      }

      /* Clock in the center */
      #clock {
        padding: 0 12px;
        font-weight: 500;
      }

      /* Right-side modules — consistent padding */
      #network,
      #bluetooth,
      #battery,
      #pulseaudio,
      #tray {
        padding: 0 10px;
      }

      /* Battery warning colors */
      #battery.warning {
        color: #fab387;
      }

      #battery.critical {
        color: #f38ba8;
      }
    '';
  };
}
