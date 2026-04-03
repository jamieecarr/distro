# NixOS Custom Desktop

A minimal, flake-based NixOS configuration for a lightweight macOS-feeling Linux desktop. Uses Hyprland as the compositor, Noctalia Shell as the desktop shell (bar, dock, launcher, notifications), and Kitty as the terminal.

## Repository Structure

```
nixos-config/
  flake.nix                    # Flake entry point (nixpkgs + home-manager + noctalia)
  hosts/laptop/
    configuration.nix          # System config (boot, networking, users, packages)
    hardware.nix               # Hardware config (placeholder — regenerate on target)
  home/
    default.nix                # Home-manager entry point
    hyprland.nix               # Hyprland compositor settings
    noctalia.nix               # Noctalia Shell (bar, dock, launcher, notifications, OSD)
    terminal.nix               # Kitty terminal
    shell.nix                  # Zsh + Starship prompt
    theme.nix                  # GTK theme, fonts, cursors, colors
    screenshot.nix             # Screenshot tools (grim + slurp)
    waybar.nix                 # (unused — kept as fallback if you drop Noctalia)
    rofi.nix                   # (unused — kept as fallback)
    dock.nix                   # (unused — kept as fallback)
    notifications.nix          # (unused — kept as fallback)
  iso.nix                      # Live ISO builder module
```

## Desktop Shell

This config uses [Noctalia Shell](https://noctalia.dev/) as the unified desktop shell. Noctalia provides:

- **Top bar** with workspaces, clock, system tray, battery, network, bluetooth
- **App launcher** (Spotlight-style, triggered with `SUPER+Space`)
- **Dock** at the bottom with pinned apps and running indicators
- **Notification center** with popup notifications and a sidebar panel
- **Lock screen** and idle management
- **OSD** (on-screen display) for volume and brightness changes
- **Control center** (`SUPER+S`) with quick settings
- **Settings panel** (`SUPER+,`) for shell configuration

All of this is a single process (`noctalia-shell`) — no need for separate waybar, rofi, swaync, etc.

## Prerequisites

Install Nix with flakes enabled. On macOS or Linux:

```bash
# Install Nix (multi-user installation)
sh <(curl -L https://nixos.org/nix/install) --daemon

# Enable flakes (add to ~/.config/nix/nix.conf)
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

## 1. Build the ISO

The ISO can be built on macOS (with a Linux builder) or on any Linux machine with Nix installed.

### On a Linux machine (or NixOS)

```bash
cd nixos-config
nix build .#nixosConfigurations.iso.config.system.build.isoImage
```

The ISO will be at `./result/iso/nixos-custom-desktop.iso`.

### On macOS

Nix can't build Linux packages natively on macOS. You need a Linux builder. Options:

**Option A: Use a remote Linux builder** (if you have a Linux server or VM)

```bash
# Add to /etc/nix/nix.conf or ~/.config/nix/nix.conf:
#   builders = ssh://user@linux-host x86_64-linux
# Then build normally:
nix build .#nixosConfigurations.iso.config.system.build.isoImage
```

**Option B: Use a NixOS VM on your Mac** (via UTM, OrbStack, or Lima)

Set up a NixOS VM, clone this repo inside it, and build there.

**Option C: Use `nixos-generators`** (community tool)

```bash
nix run github:nix-community/nixos-generators -- \
  --format iso \
  --flake .#iso
```

## 2. Flash the ISO to USB

Once you have the ISO file:

```bash
# Find your USB device (BE CAREFUL — this erases the drive)
# macOS:
diskutil list                 # Find the USB (e.g., /dev/disk4)
diskutil unmountDisk /dev/disk4
sudo dd if=./result/iso/nixos-custom-desktop.iso of=/dev/rdisk4 bs=4M status=progress
diskutil eject /dev/disk4

# Linux:
lsblk                        # Find the USB (e.g., /dev/sdb)
sudo dd if=./result/iso/nixos-custom-desktop.iso of=/dev/sdb bs=4M status=progress
sync
```

Alternatively, use [Balena Etcher](https://etcher.balena.io/) for a GUI-based approach.

## 3. Boot and Install to Disk

1. **Boot from USB**: Plug in the USB, restart the laptop, and select the USB from the boot menu (usually F12, F2, or Esc during POST).

2. **Connect to WiFi** (if needed):
   ```bash
   nmcli device wifi list
   nmcli device wifi connect "YourNetwork" password "YourPassword"
   ```

3. **Partition the disk**: Use `gparted` (included in the ISO) or the command line:
   ```bash
   # Example: create a GPT partition table with EFI + root
   sudo parted /dev/nvme0n1 -- mklabel gpt
   sudo parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 512MiB
   sudo parted /dev/nvme0n1 -- set 1 esp on
   sudo parted /dev/nvme0n1 -- mkpart primary ext4 512MiB 100%

   # Format
   sudo mkfs.fat -F32 -n boot /dev/nvme0n1p1
   sudo mkfs.ext4 -L nixos /dev/nvme0n1p2
   ```

4. **Mount partitions**:
   ```bash
   sudo mount /dev/disk/by-label/nixos /mnt
   sudo mkdir -p /mnt/boot
   sudo mount /dev/disk/by-label/boot /mnt/boot
   ```

5. **Generate hardware config**:
   ```bash
   sudo nixos-generate-config --root /mnt
   # This creates /mnt/etc/nixos/hardware-configuration.nix
   ```

6. **Clone this repo and set up config**:
   ```bash
   cd /mnt/etc
   sudo git clone <your-repo-url> nixos-config
   # Copy the generated hardware config into the repo
   sudo cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos-config/hosts/laptop/hardware.nix
   ```

7. **Install**:
   ```bash
   sudo nixos-install --flake /mnt/etc/nixos-config#laptop
   ```

8. **Set password and reboot**:
   ```bash
   # Set a password for your user
   sudo nixos-enter --root /mnt -c "passwd user"
   reboot
   ```

## 4. Rebuild After Making Config Changes

After installation, when you edit any `.nix` file:

```bash
# Apply changes (builds and switches to new config)
sudo nixos-rebuild switch --flake /etc/nixos-config#laptop

# Or test without making it the default boot entry:
sudo nixos-rebuild test --flake /etc/nixos-config#laptop

# Or build without switching (just to check for errors):
sudo nixos-rebuild build --flake /etc/nixos-config#laptop
```

## 5. Roll Back if Something Breaks

NixOS keeps every previous configuration as a "generation". Rolling back is safe and instant.

### At the boot menu

Each `nixos-rebuild switch` creates a new boot entry. If your latest config breaks the desktop, reboot and select an older generation from the systemd-boot menu.

### From the command line

```bash
# List all generations
sudo nix-env --list-generations -p /nix/var/nix/profiles/system

# Roll back to the previous generation
sudo nixos-rebuild switch --rollback

# Or switch to a specific generation
sudo nix-env --switch-generation 42 -p /nix/var/nix/profiles/system
sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch
```

### Home-manager rollback

Home-manager also keeps generations:

```bash
# List home-manager generations
home-manager generations

# Roll back
home-manager switch --rollback
```

## Key Bindings

| Key | Action |
|-----|--------|
| `SUPER + Return` | Open terminal (Kitty) |
| `SUPER + Space` | Open app launcher (Noctalia) |
| `SUPER + S` | Toggle control center sidebar |
| `SUPER + ,` | Open Noctalia settings |
| `SUPER + Q` | Close window |
| `SUPER + F` | Toggle fullscreen |
| `SUPER + SHIFT + Space` | Toggle floating |
| `SUPER + H/J/K/L` | Move focus (vim-style) |
| `SUPER + 1-9` | Switch workspace |
| `SUPER + SHIFT + 1-9` | Move window to workspace |
| `SUPER + SHIFT + S` | Screenshot region select |
| `Print` | Screenshot full screen |
| `SUPER + SHIFT + E` | Exit Hyprland |
| 3-finger swipe | Switch workspace |
| Volume keys | Volume up/down/mute (with OSD) |
| Brightness keys | Brightness up/down (with OSD) |

## Switching Back to Standalone Tools

If you want to go back to Waybar + Rofi + swaync instead of Noctalia:

1. In `home/default.nix`, comment out `./noctalia.nix` and uncomment `./waybar.nix`, `./rofi.nix`, `./dock.nix`, `./notifications.nix`
2. In `home/hyprland.nix`, change `exec-once` to launch `waybar`, `swaync`, and `nwg-dock-hyprland` instead of `noctalia-shell`
3. Update the keybinds to use `rofi -show drun` and `swaync-client` instead of the Noctalia IPC commands
4. Rebuild: `sudo nixos-rebuild switch --flake /etc/nixos-config#laptop`
