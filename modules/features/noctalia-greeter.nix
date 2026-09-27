{ inputs, ... }: {
  flake.nixosModules.noctaliaGreeter = {
    imports = [ inputs.noctalia-greeter.nixosModules.default ];
    nixpkgs.overlays = [ inputs.noctalia-greeter.overlays.default ];
    services.displayManager.noctalia-greeter = {
      enable = true;
      settings.session.default = "umbriel";
    };
  };
}
