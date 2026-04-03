# Hyprland compositor configuration.
# Hyprland is a dynamic tiling Wayland compositor with smooth animations.
# This file configures look-and-feel, keybinds, input, and window rules.
#
# The desktop shell (bar, dock, launcher, notifications) is handled by
# Noctalia — see noctalia.nix. This file only configures the compositor.

{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      # ---------- General appearance ----------
      general = {
        gaps_in = 5;       # Gap between tiled windows (px)
        gaps_out = 10;     # Gap between windows and screen edges (px)
        border_size = 2;
        # Active window border — uses a gradient from blue to purple
        "col.active_border" = "rgba(7aa2f7ff) rgba(bb9af7ff) 45deg";
        # Inactive window border — subtle gray
        "col.inactive_border" = "rgba(414868ff)";
        layout = "dwindle";  # Tiling layout: dwindle (binary split)
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
        # These are Hyprland's default animations — smooth and tasteful.
        # You can customize curves and durations later.
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
        # Touchpad settings — natural scroll means content follows finger
        # direction (like macOS).
        touchpad = {
          natural_scroll = true;
          tap-to-click = true;
        };

        # Keyboard repeat rate (how fast keys repeat when held)
        repeat_rate = 30;
        repeat_delay = 300;
      };

      # ---------- Gestures ----------
      gestures = {
        workspace_swipe = true;          # Enable 3-finger swipe to switch workspaces
        workspace_swipe_fingers = 3;
      };

      # ---------- Tiling layout settings ----------
      dwindle = {
        pseudotile = true;    # Allow windows to choose their own size within tile
        preserve_split = true; # Keep split direction when moving windows
      };

      # ---------- Noctalia IPC variable ----------
      # Noctalia exposes controls via IPC. This variable keeps keybinds clean.
      # Use `qs -c noctalia-shell ipc show` to discover all available commands.
      "$ipc" = "qs -c noctalia-shell ipc call";

      # ---------- Keybinds ----------
      # Format: MODS, key, dispatcher, params
      # SUPER = the "Windows" or "Command" key
      bind = [
        # Core actions
        "SUPER, Return, exec, kitty"              # Open terminal
        "SUPER, Q, killactive"                      # Close focused window
        "SUPER SHIFT, E, exit"                      # Exit Hyprland (logout)
        "SUPER, F, fullscreen"                      # Toggle fullscreen
        "SUPER SHIFT, Space, togglefloating"        # Toggle floating mode

        # Noctalia shell controls
        "SUPER, Space, exec, $ipc launcher toggle"          # App launcher (Spotlight-style)
        "SUPER, S, exec, $ipc controlCenter toggle"         # Control center sidebar
        "SUPER, comma, exec, $ipc settings toggle"          # Noctalia settings panel

        # Screenshots — macOS-style capture keybinds
        # Print = full screen capture (like Cmd+Shift+3 on macOS)
        ", Print, exec, grim ~/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png && wl-copy < ~/Pictures/Screenshots/$(ls -t ~/Pictures/Screenshots/ | head -1)"
        # SUPER+SHIFT+S = region select capture (like Cmd+Shift+4 on macOS)
        "SUPER SHIFT, S, exec, grim -g \"$(slurp)\" ~/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png && wl-copy < ~/Pictures/Screenshots/$(ls -t ~/Pictures/Screenshots/ | head -1)"

        # Move focus between windows (vim-style)
        "SUPER, H, movefocus, l"   # Focus left
        "SUPER, L, movefocus, r"   # Focus right
        "SUPER, K, movefocus, u"   # Focus up
        "SUPER, J, movefocus, d"   # Focus down

        # Switch workspaces (SUPER + number)
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"

        # Move focused window to workspace (SUPER + SHIFT + number)
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
      # Noctalia has built-in OSD (on-screen display) for volume and brightness.
      # bindel = repeatable key (held down). bindl = one-shot even when locked.
      bindel = [
        ", XF86AudioRaiseVolume, exec, $ipc volume increase"
        ", XF86AudioLowerVolume, exec, $ipc volume decrease"
        ", XF86MonBrightnessUp, exec, $ipc brightness increase"
        ", XF86MonBrightnessDown, exec, $ipc brightness decrease"
      ];

      bindl = [
        ", XF86AudioMute, exec, $ipc volume muteOutput"
      ];

      # Mouse binds — hold SUPER and drag to move/resize floating windows
      bindm = [
        "SUPER, mouse:272, movewindow"    # SUPER + left click drag = move
        "SUPER, mouse:273, resizewindow"  # SUPER + right click drag = resize
      ];

      # ---------- Window rules ----------
      # Make specific apps float instead of tiling.
      windowrulev2 = [
        "float, class:^(pavucontrol)$"   # Audio mixer always floats
        "float, title:^(Picture-in-Picture)$"  # Firefox PiP
      ];

      # ---------- Autostart ----------
      # Noctalia Shell handles the bar, dock, notifications, and launcher.
      # It's started as a single process — no need for separate waybar/swaync/dock.
      exec-once = [
        "noctalia-shell"
      ];
    };
  };
}
