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

    (pkgs.writeShellScriptBin "idea-wayland" ''
      export _JAVA_AWT_WM_NONPARENTING=1
      export GDK_BACKEND=wayland
      exec ${pkgs.jetbrains.idea}/bin/idea -Dawt.toolkit.name=WLToolkit "$@"
    '')
  ];
}
