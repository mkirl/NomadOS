# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

NomadOS is a NixOS flake-based system configuration managing multiple machines. It uses Nix flakes with Home Manager for declarative system and user-level configuration. The window manager is niri (Wayland tiling WM) with noctalia as the shell/bar and noctalia-greeter as the display manager.

The flake is organized using the **dendritic pattern**: `flake.nix` calls `import-tree` over `modules/` instead of listing imports by hand, so every `.nix` file under `modules/` is auto-discovered and imported as its own flake-parts module. See `README.md` for a full explanation of the pattern and directory layout.

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

The flake defines three NixOS configurations, each assembled in `modules/hosts/<machine>/default.nix`:

- **`desktop`** (x86_64-linux) - Desktop with NVIDIA GPU, user `mike`
- **`thinkpad`** (x86_64-linux) - ThinkPad laptop with Intel GPU, LUKS encryption, bluetooth support, user `mike`
- **`vm`** (aarch64-linux) - ARM VM for testing, user `mikey`

### Flake Inputs

- `nixpkgs` (nixos-unstable)
- `flake-parts` / `import-tree` - drive the dendritic module structure (see below)
- `home-manager` - per-user package/config management
- `niri` - niri-flake (Wayland compositor), with overlay applied on desktop/thinkpad
- `ghostty` - Ghostty terminal (installed on desktop/thinkpad via `home.packages`)
- `noctalia` / `noctalia-greeter` - shell/bar and display manager

### Directory Layout

- `flake.nix` - `mkFlake { inherit inputs; } (import-tree ./modules)`; no manual import list
- `modules/parts.nix` - flake-parts `systems` declaration
- `modules/features/` - one file per reusable NixOS feature, each exposing `flake.nixosModules.<name>`:
  - `dev.nix` - Enables nix-ld (for Mason/dynamic binary compatibility)
  - `distrobox.nix` - Podman with Docker compat
  - `fonts.nix` - Nerd Fonts
  - `home-manager.nix` - wires up the Home Manager NixOS module
  - `niri.nix` - niri-unstable + caps-to-escape remap
  - `noctalia.nix` / `noctalia-greeter.nix` - noctalia shell and greeter
- `modules/home/common.nix` - shared Home Manager config exposed as `flake.homeModules.common` (shell, editor, dev tools, desktop entries, GTK/cursor theming), imported by all machines
- `modules/hosts/<machine>/default.nix` - builds `flake.nixosConfigurations.<machine>` by importing `hosts/<machine>/configuration.nix` plus the `self.nixosModules.*` features that machine needs, and sets up its Home Manager user via `self.homeModules.common`
- `hosts/<machine>/configuration.nix` - Per-machine low-level NixOS system config (hardware, drivers, networking, services)
- `hosts/<machine>/hardware-configuration.nix` - Auto-generated hardware config (do not edit manually)
- `wallpapers/` - wallpapers referenced by noctalia config

### Key Patterns

- New features are added as new files under `modules/features/`; import-tree picks them up automatically, so nothing else needs editing to make a module available - a host still has to opt in via `self.nixosModules.<name>` in its `modules/hosts/<machine>/default.nix`
- Desktop/thinkpad share the niri, distrobox, and noctalia-greeter modules; the VM does not use distrobox, niri, or noctalia-greeter
- JetBrains IDEs and Discord use custom desktop entries with Wayland-specific flags (`-Dawt.toolkit.name=WLToolkit`, `--ozone-platform=wayland`)
- The shell is Fish across all machines, with direnv + nix-direnv, zoxide, and starship enabled
- Zed is the configured text editor (x86_64 hosts only)
