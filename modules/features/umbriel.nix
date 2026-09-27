{ inputs, ... }: {
  flake.nixosModules.umbriel = {
    imports = [ inputs.umbriel.nixosModules.default ];
    programs.umbriel.enable = true;
    services.xserver.xkb.options = "caps:escape";
  };
}
