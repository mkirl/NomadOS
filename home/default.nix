{ config, pkgs, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
      fastfetch
    '';
  };


  programs.git = {
    enable = true;
    userName = "Mike";
    userEmail = "michael.e.kirl@gmail.com";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.packages = with pkgs; [
    htop
    ripgrep
    fd
    tree
    neovim
    zed-editor
    claude-code
    solaar
    zellij
    fastfetch
    discord
    jetbrains.idea-ultimate
    jetbrains.clion
    distrobox
  ];

  xdg.desktopEntries.idea = {
    name = "IntelliJ IDEA";
    exec = "idea -Dawt.toolkit.name=WLToolkit %u";
    icon = "idea";
    terminal = false;
    categories = [ "Development" "IDE" ];
  };

  xdg.desktopEntries.clion = {
    name = "CLion";
    exec = "clion -Dawt.toolkit.name=WLToolkit %u";
    icon = "clion";
    terminal = false;

    categories = [ "Development" "IDE" ];
  };

  xdg.desktopEntries.discord = {
    name = "Discord";
    exec = "discord --enable-features=UseOzonePlatform --ozone-platform=wayland";
    icon = "discord";
    terminal = false;
    categories = [ "Network" "InstantMessaging" ];
  };

  home.stateVersion = "25.11";

}
