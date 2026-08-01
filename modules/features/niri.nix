{ inputs, ... }: {
  flake.nixosModules.niri = { pkgs, ... }: {
    imports = [ inputs.niri.nixosModules.niri ];
    nixpkgs.overlays = [ inputs.niri.overlays.niri ];
    programs.niri.enable = true;
    programs.niri.package = pkgs.niri-unstable;
    services.xserver.xkb.options = "caps:escape";
  };
}
