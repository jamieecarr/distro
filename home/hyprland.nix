# Hyprland compositor configuration.
# Hyprland is a Wayland compositor with smooth animations.
# This file configures look-and-feel, keybinds, input, and window rules.
#
# The desktop shell (bar, dock, launcher, notifications) is handled by
# Noctalia — see noctalia.nix. This file only configures the compositor.
#
# All windows float by default (like macOS) — no tiling.

{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      # ---------- General appearance ----------
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(7aa2f7ff) rgba(bb9af7ff) 45deg";
        "col.inactive_border" = "rgba(414868ff)";
      };

      # ---------- Decoration (rounded corners, blur, shadows) ----------
      decoration = {
        rounding = 10;

        blur = {
          enabled = true;
          size = 6;
          passes = 2;
          new_optimizations = true;
        };

        shadow = {
          enabled = true;
          range = 15;
          render_power = 2;
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
          natural_scroll = true;
          tap-to-click = true;
        };
        repeat_rate = 30;
        repeat_delay = 300;
      };

      # ---------- Keybinds ----------
      bind = [
        "SUPER, Return, exec, kitty"
        "SUPER, Q, killactive"
        "SUPER SHIFT, E, exit"
        "SUPER, F, fullscreen"

        # Noctalia shell controls (IPC commands inlined to avoid $ escaping issues)
        "SUPER, Space, exec, qs -c noctalia-shell ipc call launcher toggle"
        "SUPER, S, exec, qs -c noctalia-shell ipc call controlCenter toggle"
        "SUPER, comma, exec, qs -c noctalia-shell ipc call settings toggle"

        # Screenshots
        ", Print, exec, grim ~/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png"
        "SUPER SHIFT, S, exec, grim -g \"$(slurp)\" ~/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png"

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
        ", XF86AudioRaiseVolume, exec, qs -c noctalia-shell ipc call volume increase"
        ", XF86AudioLowerVolume, exec, qs -c noctalia-shell ipc call volume decrease"
        ", XF86MonBrightnessUp, exec, qs -c noctalia-shell ipc call brightness increase"
        ", XF86MonBrightnessDown, exec, qs -c noctalia-shell ipc call brightness decrease"
      ];

      bindl = [
        ", XF86AudioMute, exec, qs -c noctalia-shell ipc call volume muteOutput"
      ];

      # Mouse binds — drag to move/resize windows
      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];

      # ---------- Window rules ----------
      windowrule = [
        "float, class:.*"
        "float, title:^(Picture-in-Picture)$"
      ];

      # ---------- Autostart ----------
      exec-once = [
        "noctalia-shell"
      ];
    };

    # ---------- Extra config ----------
    # Gestures removed for now — the new gesture syntax from Hyprland 0.51+
    # may not be available in the version bundled with nixpkgs-unstable yet.
    # Add them back once your Hyprland version supports the gesture keyword.
  };
}
