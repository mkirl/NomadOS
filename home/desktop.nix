{ config, pkgs, ghostty, ... }:

{
  imports = [ ./default.nix ];

  # Desktop-specific packages
  home.packages = [
    ghostty.packages.x86_64-linux.default
  ];
}
