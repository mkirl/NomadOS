{ ... }: {
  flake.nixosModules.dev = {
    programs.nix-ld.enable = true;
  };
}
