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
  };

  outputs = { self, nixpkgs, home-manager, niri, ghostty, ... }: {
    nixosConfigurations.vm = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [ 
        ./hosts/vm/configuration.nix 
        home-manager.nixosModules.home-manager
        niri.nixosModules.niri
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.mikey = import ./home/vm.nix;
        }
        {
          programs.niri.enable = true;
          programs.dms-shell.enable = true;
        }
      ];
    };

    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit ghostty; };
      modules = [
        ./hosts/desktop/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.mike = import ./home/desktop.nix;
          home-manager.extraSpecialArgs = { inherit ghostty; };
        }
        {
          programs.niri.enable = true;
          programs.dms-shell.enable = true;
        }
      ];
    };

    nixosConfigurations.thinkpad = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit ghostty; };
      modules = [
        ./hosts/thinkpad/configuration.nix
        home-manager.nixosModules.home-manager
        niri.nixosModules.niri
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.mike = import ./home/thinkpad.nix;
          home-manager.extraSpecialArgs = { inherit ghostty; };
        }
        {
          programs.niri.enable = true;
	  programs.dms-shell = {
	    enable = true;
	    systemd.enable = true;
	    enableSystemMonitoring = true;
	    enableClipboard = true;
	    enableVPN = true;
	    enableDynamicTheming = true;
	    enableAudioWavelength = true;
	    enableCalendarEvents = true;
        };
      ];
    };
  };
}
