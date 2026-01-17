{ config, pkgs, ... }:

{
  home.username = "mikey";
  home.homeDirectory = "/home/mikey";

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
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
  ];

  home.stateVersion = "25.11";

}
