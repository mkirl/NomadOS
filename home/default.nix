{ config, pkgs, ... }:

{
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
    neovim
    claude-code
  ];

  home.stateVersion = "25.11";

}
