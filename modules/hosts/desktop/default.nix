{ self, inputs, ... }: {
  flake.nixosConfigurations.desktop = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ../../../hosts/desktop/configuration.nix
      self.nixosModules.niri
      self.nixosModules.noctalia
      self.nixosModules.noctaliaGreeter
      self.nixosModules.dev
      self.nixosModules.distrobox
      self.nixosModules.fonts
      self.nixosModules.homeManager
      self.nixosModules.mosh
      {
        home-manager.users.mike = { pkgs, ... }: {
          imports = [ self.homeModules.common self.homeModules.zed ];
          home.username = "mike";
          home.homeDirectory = "/home/mike";
          home.packages = [
            inputs.ghostty.packages.x86_64-linux.default
            pkgs.vscode
            pkgs.firefox
          ];
        };
      }
    ];
  };
}
