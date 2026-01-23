{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-uuid/1778ae37-7093-4caf-b5dc-5c34e50fba11";
  };

  networking.hostName = "thinkpad";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago";

  # Intel Graphics
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver 
      libva-vdpau-driver 
      libvdpau-va-gl
    ];
  };

  # Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
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

  # Enable trackpad?
  services.libinput.enable = true;

  # Laptop power management
  services.thermald.enable = true;
  services.upower.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Backlight
  programs.light.enable = true;

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.11";
}
