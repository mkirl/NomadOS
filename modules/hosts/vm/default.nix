{ self, inputs, ... }: {
  flake.nixosConfigurations.vm = inputs.nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    modules = [
      ../../../hosts/vm/configuration.nix
      self.nixosModules.niri
      self.nixosModules.noctalia
      self.nixosModules.dev
      self.nixosModules.homeManager
      {
        home-manager.users.mikey = { pkgs, ... }: {
          imports = [ self.homeModules.common ];
          home.username = "mikey";
          home.homeDirectory = "/home/mikey";
          home.packages = [
            pkgs.foot
          ];
        };
      }
    ];
  };
}
