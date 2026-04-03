# Hardware-specific configuration.
#
# THIS FILE IS A PLACEHOLDER. On your target laptop, regenerate it with:
#
#   sudo nixos-generate-config --show-hardware-config > hosts/laptop/hardware.nix
#
# That command detects your specific hardware (CPU, GPU, disk partitions,
# filesystems, kernel modules) and generates the correct config.
#
# The placeholder below provides enough to build and evaluate the config,
# but it won't boot on real hardware until you replace it with the
# generated output.

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    # This pulls in kernel modules and settings detected at install time.
    # The generated hardware config will include this automatically.
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # ---------- Boot ----------
  boot.initrd.availableKernelModules = [
    "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod"
  ];
  boot.kernelModules = [ "kvm-intel" ];  # Change to kvm-amd for AMD CPUs

  # ---------- Filesystems ----------
  # These are placeholders. The generated config will have your real
  # partition UUIDs and mount points.
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  swapDevices = [ ];

  # ---------- Networking ----------
  # Detected network interfaces will be listed here in the generated config.
}
