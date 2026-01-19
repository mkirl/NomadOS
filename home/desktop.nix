{ config, pkgs, ghostty, ... }:

{
  imports = [ ./default.nix ];

  home.username = "mike";
  home.homeDirectory = "/home/mike";

  home.packages = [
    ghostty.packages.x86_64-linux.default
    pkgs.vscode
    pkgs.firefox
    pkgs.zed-editor

    (pkgs.writeShellScriptBin "idea" ''
      exec ${pkgs.jetbrains.idea-ultimate}/bin/idea-ultimate -Dawt.toolkit=name=WLToolkit "$@"
    '')
  ];
}
