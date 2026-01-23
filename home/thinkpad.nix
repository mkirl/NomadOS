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
    pkgs.jetbrains.idea-ultimate
  ];

  xdg.desktopEntries.idea = {
    name = "Intellij IDEA";
    exec = "idea -Dawt.toolkit.name=WLToolkit %u";
    icon = "idea";
    terminal = false;
    categories = [ "Development" "IDE" ];
  };
}
