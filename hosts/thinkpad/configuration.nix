{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-uuid/by-uuid/1778ae37-7093-4caf-b5dc-5c34e50fba11";
  };

  networking.hostName = "thinkpad";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago";

  # Intel Graphics
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users.users.mike = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" ];
    shell = pkgs.fish;
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    curl
    wget
  ];

  programs.fish.enable = true;
  services.openssh.enable = true;
  services.tailscale.enable = true;

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "mike" ];
  };

  # Laptop power management
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    };
  };
  services.thermald.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Backlight
  programs.light.enable = true;

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.11";
}
