# Hyprland compositor configuration.
# Hyprland is a Wayland compositor with smooth animations.
# This file configures look-and-feel, keybinds, input, and window rules.
#
# The desktop shell (bar, dock, launcher, notifications) is handled by
# Noctalia — see noctalia.nix. This file only configures the compositor.
#
# Layout is set to floating (like macOS) — all windows are freely
# movable and resizable by default. No tiling.

{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      # ---------- General appearance ----------
      general = {
        gaps_in = 5;       # Gap between windows (px)
        gaps_out = 10;     # Gap between windows and screen edges (px)
        border_size = 2;
        # Active window border — uses a gradient from blue to purple
        "col.active_border" = "rgba(7aa2f7ff) rgba(bb9af7ff) 45deg";
        # Inactive window border — subtle gray
        "col.inactive_border" = "rgba(414868ff)";
      };

      # ---------- Decoration (rounded corners, blur, shadows) ----------
      decoration = {
        rounding = 10;  # Corner radius on windows

        blur = {
          enabled = true;
          size = 6;           # Blur kernel size
          passes = 2;         # More passes = smoother blur, more GPU cost
          new_optimizations = true;
        };

        # Subtle drop shadow behind windows
        shadow = {
          enabled = true;
          range = 15;
          render_power = 2;    # Falloff sharpness (1-4)
          color = "rgba(00000055)";
        };
      };

      # ---------- Animations ----------
      animations = {
        enabled = true;
        bezier = [
          "ease, 0.25, 0.1, 0.25, 1.0"
          "overshot, 0.05, 0.9, 0.1, 1.1"
        ];
        animation = [
          "windows, 1, 5, overshot, slide"
          "windowsOut, 1, 5, ease, slide"
          "fade, 1, 5, ease"
          "workspaces, 1, 5, ease, slide"
        ];
      };

      # ---------- Input (keyboard, touchpad) ----------
      input = {
        touchpad = {
          natural_scroll = true;   # Scroll direction like macOS
          tap-to-click = true;
        };

        repeat_rate = 30;
        repeat_delay = 300;
      };

      # ---------- Gestures ----------
      # Hyprland 0.51+ uses per-gesture definitions instead of the old
      # gestures { workspace_swipe } block.
      gesture = [
        "3, left, workspace, +1"    # 3-finger swipe left = next workspace
        "3, right, workspace, -1"   # 3-finger swipe right = previous workspace
      ];

      # ---------- Noctalia IPC variable ----------
      "$ipc" = "qs -c noctalia-shell ipc call";

      # ---------- Keybinds ----------
      bind = [
        # Core actions
        "SUPER, Return, exec, kitty"              # Open terminal
        "SUPER, Q, killactive"                      # Close focused window
        "SUPER SHIFT, E, exit"                      # Exit Hyprland (logout)
        "SUPER, F, fullscreen"                      # Toggle fullscreen

        # Noctalia shell controls
        "SUPER, Space, exec, $ipc launcher toggle"          # App launcher
        "SUPER, S, exec, $ipc controlCenter toggle"         # Control center sidebar
        "SUPER, comma, exec, $ipc settings toggle"          # Settings panel

        # Screenshots
        ", Print, exec, grim ~/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png && wl-copy < ~/Pictures/Screenshots/$(ls -t ~/Pictures/Screenshots/ | head -1)"
        "SUPER SHIFT, S, exec, grim -g \"$(slurp)\" ~/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png && wl-copy < ~/Pictures/Screenshots/$(ls -t ~/Pictures/Screenshots/ | head -1)"

        # Move focus between windows
        "SUPER, H, movefocus, l"
        "SUPER, L, movefocus, r"
        "SUPER, K, movefocus, u"
        "SUPER, J, movefocus, d"

        # Switch workspaces
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"

        # Move focused window to workspace
        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"
        "SUPER SHIFT, 6, movetoworkspace, 6"
        "SUPER SHIFT, 7, movetoworkspace, 7"
        "SUPER SHIFT, 8, movetoworkspace, 8"
        "SUPER SHIFT, 9, movetoworkspace, 9"
      ];

      # ---------- Media keys ----------
      bindel = [
        ", XF86AudioRaiseVolume, exec, $ipc volume increase"
        ", XF86AudioLowerVolume, exec, $ipc volume decrease"
        ", XF86MonBrightnessUp, exec, $ipc brightness increase"
        ", XF86MonBrightnessDown, exec, $ipc brightness decrease"
      ];

      bindl = [
        ", XF86AudioMute, exec, $ipc volume muteOutput"
      ];

      # Mouse binds — drag to move/resize windows (like macOS with SUPER held)
      bindm = [
        "SUPER, mouse:272, movewindow"    # SUPER + left click drag = move
        "SUPER, mouse:273, resizewindow"  # SUPER + right click drag = resize
      ];

      # ---------- Window rules ----------
      # windowrulev2 renamed to windowrule in Hyprland 0.51+
      windowrule = [
        "float, class:^(pavucontrol)$"
        "float, title:^(Picture-in-Picture)$"
        # Make ALL windows float by default (macOS-style free-moving windows)
        "float, class:.*"
      ];

      # ---------- Autostart ----------
      exec-once = [
        "noctalia-shell"
      ];
    };
  };
}
