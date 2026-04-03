# ISO builder module.
# This module configures a bootable live ISO image that boots directly
# into the Hyprland desktop with all the config baked in.
#
# Build with:
#   nix build .#nixosConfigurations.iso.config.system.build.isoImage
#
# The result will be in ./result/iso/

{ config, pkgs, lib, modulesPath, ... }:

{
  imports = [
    # This NixOS module provides the machinery to build ISO images.
    # It sets up the live filesystem, squashfs compression, and boot menu.
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
  ];

  # ---------- ISO-specific overrides ----------

  # The ISO uses its own filesystem detection — don't conflict with
  # the placeholder hardware.nix filesystems.
  fileSystems = lib.mkForce { };
  swapDevices = lib.mkForce [ ];

  # The ISO boots via its own mechanism, not systemd-boot.
  # Override the systemd-boot config from configuration.nix.
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;

  # ---------- Live session packages ----------
  # Include tools needed to install NixOS to disk from the live session.
  environment.systemPackages = with pkgs; [
    git                # Clone this repo on the target machine
    vim                # Edit configs during install
    gparted            # GUI partition editor (useful for install prep)
  ];

  # ---------- ISO metadata ----------
  isoImage.isoName = "nixos-custom-desktop.iso";
}
