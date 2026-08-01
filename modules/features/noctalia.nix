{ inputs, ... }: {
  flake.nixosModules.noctalia = {
    nixpkgs.overlays = [ inputs.noctalia.overlays.default ];
    programs.noctalia = {
      enable = true;
      systemd.enable = true;
      recommendedServices.enable = true;
    };
  };
}
