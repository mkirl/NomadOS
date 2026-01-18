{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-vm";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago";

  users.users.mikey = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "changeme";
    shell = pkgs.fish;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    git
    vim
    curl
    wget
  ];

  programs.dms-shell = {
    enable = true;
    systemd.enable = true;

    enableSystemMonitoring = true;
    enableClipboard = true;
    enableDynamicTheming = true;
  };

  programs.fish.enable = true;

  services.openssh.enable = true;

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.11";
}
