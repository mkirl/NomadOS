{ self, inputs, ... }: {
  flake.nixosConfigurations.thinkpad = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ../../../hosts/thinkpad/configuration.nix
      self.nixosModules.niri
      self.nixosModules.noctalia
      self.nixosModules.noctaliaGreeter
      self.nixosModules.dev
      self.nixosModules.distrobox
      self.nixosModules.homeManager
      {
        home-manager.users.mike = { pkgs, ... }: {
          imports = [ self.homeModules.common ];
          home.username = "mike";
          home.homeDirectory = "/home/mike";
          home.packages = [
            inputs.ghostty.packages.x86_64-linux.default
            pkgs.vscode
            pkgs.firefox
            pkgs.xwayland-satellite
          ];
        };
      }
    ];
  };
}
