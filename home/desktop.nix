{ config, pkgs, ghostty, ... }:

{
  imports = [ ./default.nix ];

  home.username = "mike";
  home.homeDirectory = "/home/mike";

  home.packages = [
    ghostty.packages.x86_64-linux.default
  ];


  programs.firefox.enable = true;

  programs.vscode = {
    programs = true;
    package = pkgs.vscode;
  };
}
