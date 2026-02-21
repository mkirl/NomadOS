# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

NomadOS is a NixOS flake-based system configuration managing multiple machines. It uses Nix flakes with Home Manager for declarative system and user-level configuration. The window manager is niri (Wayland tiling WM) with the dms-shell/dms-greeter display manager.

## Build Commands

Rebuild and switch for a specific host (run as root or with sudo):

```bash
sudo nixos-rebuild switch --flake .#desktop
sudo nixos-rebuild switch --flake .#thinkpad
sudo nixos-rebuild switch --flake .#vm
```

Update flake inputs:

```bash
nix flake update
```

Format Nix files (the repo uses nixfmt-rfc-style):

```bash
nixfmt <file.nix>
```

## Architecture

The flake defines three NixOS configurations:

- **`desktop`** (x86_64-linux) - Desktop with NVIDIA GPU, user `mike`
- **`thinkpad`** (x86_64-linux) - ThinkPad laptop with Intel GPU, LUKS encryption, battery/bluetooth/backlight support, user `mike`
- **`vm`** (aarch64-linux) - ARM VM for testing, user `mikey`

### Flake Inputs

- `nixpkgs` (nixos-unstable)
- `home-manager` - per-user package/config management
- `niri` - niri-flake (Wayland compositor), with overlay applied on desktop/thinkpad
- `ghostty` - Ghostty terminal (used on desktop/thinkpad only, passed via `specialArgs`)

### Directory Layout

- `hosts/<machine>/configuration.nix` - Per-machine NixOS system config (hardware, drivers, networking, services)
- `hosts/<machine>/hardware-configuration.nix` - Auto-generated hardware config (do not edit manually)
- `home/default.nix` - Shared Home Manager config imported by all machines (shell, editor, dev tools, desktop entries, GTK/cursor theming)
- `home/{desktop,thinkpad,vm}.nix` - Per-machine Home Manager overrides (username, machine-specific packages)
- `modules/` - Reusable NixOS modules:
  - `dev.nix` - Enables nix-ld (for Mason/dynamic binary compatibility)
  - `distrobox.nix` - Podman with Docker compat (desktop/thinkpad only)
  - `niri.nix` - niri-unstable + caps-to-escape remap (desktop/thinkpad only)
- `configuration.nix` - Base/template config (mostly commented-out defaults, not actively imported)

### Key Patterns

- Desktop/thinkpad share the niri overlay (`niri.overlays.niri`) and modules (`dev`, `distrobox`, `niri`); the VM does not use distrobox or the niri module
- JetBrains IDEs and Discord use custom desktop entries with Wayland-specific flags (`-Dawt.toolkit.name=WLToolkit`, `--ozone-platform=wayland`)
- The shell is Fish across all machines, with direnv + nix-direnv and zoxide enabled
- Helix is the configured text editor with gruvbox theme and nixfmt-rfc-style auto-formatting for `.nix` files
