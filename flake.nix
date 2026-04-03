{
  description = "Custom NixOS-based desktop — lightweight macOS-feeling Linux";

  # Optional: use Noctalia's binary cache to avoid building from source.
  # This is safe to remove if you prefer to build everything yourself.
  nixConfig = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  inputs = {
    # Using nixos-unstable to get the latest Hyprland and other packages.
    # You could pin to a specific commit for reproducibility later.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # home-manager manages per-user dotfiles and programs declaratively.
    # The "follows" line makes home-manager use the same nixpkgs as the system,
    # avoiding duplicate package downloads.
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Noctalia Shell — a unified desktop shell for Wayland.
    # Provides top bar, dock, app launcher, notifications, lock screen,
    # and OSD in a single package (replaces waybar, rofi, swaync, etc.)
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, noctalia, ... }:
  let
    # Pass flake inputs to all NixOS modules via specialArgs.
    # This lets home-manager modules access the noctalia flake.
    specialArgs = { inherit noctalia; };
  in
  {

    # ---------- Main system configuration (for installing to disk) ----------
    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      inherit specialArgs;
      modules = [
        # System-level configuration
        ./hosts/laptop/configuration.nix
        ./hosts/laptop/hardware.nix

        # Integrate home-manager as a NixOS module so it's part of
        # `nixos-rebuild switch` rather than a separate tool.
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;   # Use the system's nixpkgs instance
          home-manager.useUserPackages = true;  # Install user packages to /etc/profiles
          home-manager.extraSpecialArgs = specialArgs;  # Pass noctalia to home modules
          home-manager.users.user = import ./home;  # Load home config for "user"
        }
      ];
    };

    # ---------- Live ISO configuration (for booting from USB) ----------
    nixosConfigurations.iso = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      inherit specialArgs;
      modules = [
        # The ISO builder module adds the live CD infrastructure
        ./iso.nix

        # Pull in the same desktop configuration so the ISO boots
        # into the full Hyprland desktop
        ./hosts/laptop/configuration.nix

        # home-manager for user environment on the live ISO
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = specialArgs;
          home-manager.users.user = import ./home;
        }
      ];
    };
  };
}
