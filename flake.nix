{
  description = "UTM NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, niri, ghostty, noctalia, noctalia-greeter, ... }: {
    nixosConfigurations.vm = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        ./hosts/vm/configuration.nix
        ./modules/dev.nix 
        home-manager.nixosModules.home-manager
        niri.nixosModules.niri
        { nixpkgs.overlays = [ noctalia.overlays.default ]; }
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.mikey = import ./home/vm.nix;
          home-manager.sharedModules = [ noctalia.homeModules.default ];
        }
        {
          programs.niri.enable = true;
          programs.noctalia = {
            enable = true;
            systemd.enable = true;
          };
        }
      ];
    };

    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit ghostty; };
      modules = [
        ./hosts/desktop/configuration.nix
        ./modules/dev.nix
        ./modules/distrobox.nix
        ./modules/niri.nix
        niri.nixosModules.niri
        noctalia-greeter.nixosModules.default
        { nixpkgs.overlays = [ niri.overlays.niri noctalia.overlays.default noctalia-greeter.overlays.default ]; }
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.mike = import ./home/desktop.nix;
          home-manager.extraSpecialArgs = { inherit ghostty; };
          home-manager.sharedModules = [ noctalia.homeModules.default ];
        }
        {
          programs.noctalia = {
            enable = true;
            systemd.enable = true;
            recommendedServices.enable = true;
          };
        }
      ];
    };

    nixosConfigurations.thinkpad = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit ghostty; };
      modules = [
        ./hosts/thinkpad/configuration.nix
        ./modules/dev.nix
        ./modules/distrobox.nix
        ./modules/niri.nix
        niri.nixosModules.niri
        noctalia-greeter.nixosModules.default
        { nixpkgs.overlays = [ niri.overlays.niri noctalia.overlays.default noctalia-greeter.overlays.default ]; }
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.mike = import ./home/thinkpad.nix;
          home-manager.extraSpecialArgs = { inherit ghostty; };
          home-manager.sharedModules = [ noctalia.homeModules.default ];
        }
        {
          programs.noctalia = {
            enable = true;
            systemd.enable = true;
            recommendedServices.enable = true;
          };
        }
      ];
    };
  };
}
