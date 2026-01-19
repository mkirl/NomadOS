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
    pkgs.jetbrains.idea
    
  ];
  xdg.desktopEntries.idea = {
    name = "IntelliJ IDEA";
    exec = "idea -Dawt.toolkit.name=WLToolkit %u";
    icon = "idea";
    terminal = false;
    categories = [ "Development" "IDE" ];
  };

  programs.fish.shellAliases = {
    idea = "idea -Dawt.toolkit.name=WLToolkit &>/dev/null &; disown";
  };
}
