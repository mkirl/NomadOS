{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "desktop";
  networking.networkmanager.enable = true;

  # Timezone
  time.timeZone = "America/Chicago";

  # NVIDIA
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };
  hardware.graphics.enable = true;

  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # User
  users.users.mike = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" ];
    shell = pkgs.fish;
  };

  # System packages
  environment.systemPackages = with pkgs; [
    git
    vim
    curl
    wget
  ];

  # Fish shell
  programs.fish.enable = true;

  # SSH
  services.openssh.enable = true;

  # Tailscale
  services.tailscale.enable = true;

  services.displayManager.dms-greeter = {
    enable = true;
    compositor.name = "niri";
  };

  # 1Password
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "mike" ];
  };
  
  # Allow unfree (NVIDIA)
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.11";
}
