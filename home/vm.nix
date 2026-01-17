{ config, pkgs, ... }:

{
  imports = [ ./default.nix ];


  home.username = "mikey";
  home.homeDirectory = "/home/mikey;

  home.packages = with pkgs; [
    foot
  ];
}
