# System-level NixOS configuration.
# This is the main file that defines what the OS looks like:
# bootloader, networking, audio, users, packages, etc.

{ config, pkgs, ... }:

{
  # ---------- Bootloader ----------
  # systemd-boot is a simple UEFI bootloader. It's fast and works well
  # with NixOS's generation system (each rebuild creates a new boot entry).
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ---------- Networking ----------
  networking.hostName = "nixos";  # Change this to whatever you want
  networking.networkmanager.enable = true;  # Gives you nmcli and nmtui for WiFi

  # ---------- Time & Locale ----------
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  # ---------- Hyprland (compositor / window manager) ----------
  # This enables the Hyprland Wayland compositor at the system level.
  # The actual Hyprland settings (keybinds, animations, etc.) are in
  # home/hyprland.nix via home-manager.
  programs.hyprland.enable = true;

  # ---------- Audio (PipeWire) ----------
  # PipeWire replaces PulseAudio and JACK. It handles audio and screen
  # sharing on Wayland.
  services.pipewire = {
    enable = true;
    alsa.enable = true;        # ALSA compatibility (most Linux audio apps)
    alsa.support32Bit = true;  # 32-bit app support (some games, Wine)
    pulse.enable = true;       # PulseAudio compatibility (Firefox, etc.)
  };

  # ---------- Bluetooth ----------
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;  # Turn on Bluetooth adapter at boot

  # ---------- Power management ----------
  # These services are needed by Noctalia Shell to display battery info,
  # power profiles, and brightness controls in its bar and control center.
  services.upower.enable = true;                  # Battery monitoring daemon
  services.power-profiles-daemon.enable = true;    # Power profile switching (balanced/performance/saver)

  # ---------- Flatpak ----------
  # Flatpak lets you install apps outside of nixpkgs (e.g., from Flathub).
  # After enabling, you'll need to add the Flathub remote:
  #   flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  services.flatpak.enable = true;

  # ---------- XDG Portal ----------
  # Required for Flatpak, screen sharing, and file picker dialogs on Wayland.
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  # ---------- User account ----------
  # Creates a user called "user". Rename this to your preferred username.
  # After changing, you'll also need to update home-manager references.
  users.users.user = {
    isNormalUser = true;
    description = "Default User";
    extraGroups = [
      "wheel"           # Grants sudo access
      "networkmanager"  # Allows managing WiFi without sudo
      "video"           # Needed for brightness control
      "audio"           # Audio device access
    ];
    # Default shell — zsh is configured via home-manager in shell.nix
    shell = pkgs.zsh;
  };

  # Enable zsh at the system level (required even though config is in home-manager)
  programs.zsh.enable = true;

  # ---------- Auto-login ----------
  # Skip the display manager / login screen entirely.
  # greetd is a minimal login daemon that can auto-launch Hyprland.
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.hyprland}/bin/Hyprland";
        user = "user";
      };
    };
  };

  # ---------- System packages ----------
  # These are available to all users on the system.
  environment.systemPackages = with pkgs; [
    git              # Version control
    vim              # Text editor
    firefox          # Web browser
    nautilus          # File manager (GNOME Files)
    pavucontrol      # GUI audio mixer
    brightnessctl    # Screen brightness control from CLI
  ];

  # ---------- Nix settings ----------
  # Enable flakes and the new nix CLI commands (nix build, nix develop, etc.)
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages (firmware, some fonts, etc.)
  nixpkgs.config.allowUnfree = true;

  # ---------- NixOS version ----------
  # This determines the default settings and package set.
  # Don't change this unless you're doing a full system migration.
  system.stateVersion = "24.11";
}
