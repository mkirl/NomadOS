# NomadOS

A NixOS flake configuration for multiple machines, built with [flake-parts](https://flake.parts/) and [import-tree](https://github.com/vic/import-tree) using the **dendritic pattern**: every `.nix` file under `modules/` is a self-contained flake-parts module that is auto-discovered and imported — there is no central list of imports to maintain by hand.

## Machines

- **`desktop`** (x86_64-linux) — Desktop with NVIDIA GPU, user `mike`
- **`thinkpad`** (x86_64-linux) — ThinkPad laptop with Intel GPU, LUKS encryption, user `mike`
- **`vm`** (aarch64-linux) — ARM VM for testing, user `mikey`

Window manager is [niri](https://github.com/YaLTeR/niri) (Wayland tiling WM) with [noctalia](https://github.com/noctalia-dev/noctalia) as the shell/bar and `noctalia-greeter` as the display manager.

## The dendritic pattern

`flake.nix` does almost nothing itself:

```nix
outputs = inputs:
  inputs.flake-parts.lib.mkFlake { inherit inputs; }
    (inputs.import-tree ./modules);
```

`import-tree` walks `modules/` and imports every `.nix` file it finds as a flake-parts module. Each file is free to contribute to the flake's outputs independently — there's no `imports = [ ... ]` list to update every time a module is added or removed. Modules opt into the pieces of the flake they care about:

- **`flake.nixosModules.<name>`** — a reusable NixOS module (a "feature")
- **`flake.homeModules.<name>`** — a reusable Home Manager module
- **`flake.nixosConfigurations.<name>`** — a full machine, assembled from the modules above

Because every file is independently importable and namespaced under `flake.*`, features stay decoupled: `modules/features/niri.nix` knows nothing about `modules/hosts/desktop/default.nix`, it just registers `flake.nixosModules.niri`. Hosts then compose whichever named modules they need via `self.nixosModules.*` / `self.homeModules.*`.

## Directory layout

```
flake.nix                          # mkFlake + import-tree ./modules — no manual import list
modules/
  parts.nix                        # flake-parts systems declaration
  features/                        # one file per reusable NixOS feature
    dev.nix                        #   -> flake.nixosModules.dev (nix-ld)
    distrobox.nix                  #   -> flake.nixosModules.distrobox (podman/docker compat)
    fonts.nix                      #   -> flake.nixosModules.fonts
    home-manager.nix                #   -> flake.nixosModules.homeManager
    niri.nix                       #   -> flake.nixosModules.niri
    noctalia.nix                   #   -> flake.nixosModules.noctalia
    noctalia-greeter.nix           #   -> flake.nixosModules.noctaliaGreeter
  home/
    common.nix                     # -> flake.homeModules.common, shared Home Manager config
  hosts/
    desktop/default.nix            # -> flake.nixosConfigurations.desktop
    thinkpad/default.nix           # -> flake.nixosConfigurations.thinkpad
    vm/default.nix                 # -> flake.nixosConfigurations.vm
hosts/<machine>/
  configuration.nix                # per-machine system config (hardware, drivers, networking)
  hardware-configuration.nix       # auto-generated, do not edit manually
wallpapers/                        # wallpapers referenced by noctalia config
```

Each host under `modules/hosts/<machine>/default.nix` builds its `nixosConfigurations.<machine>` by importing the low-level `hosts/<machine>/configuration.nix` plus whichever `self.nixosModules.*` features it needs, and wires up its Home Manager user via `self.homeModules.common`.

## Adding a new feature

Drop a new file anywhere under `modules/` (e.g. `modules/features/foo.nix`) that sets `flake.nixosModules.foo = { ... }: { ... };`. It's picked up automatically — no other file needs to change. Reference it from a host's module list (`self.nixosModules.foo`) to enable it on that machine.

## Build commands

```bash
sudo nixos-rebuild switch --flake .#desktop
sudo nixos-rebuild switch --flake .#thinkpad
sudo nixos-rebuild switch --flake .#vm
```

Update flake inputs:

```bash
nix flake update
```

Format Nix files (nixfmt-rfc-style):

```bash
nixfmt <file.nix>
```
