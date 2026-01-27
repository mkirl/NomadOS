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
  ];

  home.keyboard = {
    options = [ "caps:escape" ];
  };

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

  home.stateVersion = "25.11";

}
