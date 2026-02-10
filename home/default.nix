{ config, pkgs, lib, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
      fastfetch
    '';
    functions = {
      idea = "command idea -Dawt.toolkit.name=WLToolkit $argv &>/dev/null &; disown";
      clion = "command clion -Dawt.toolkit.name=WLToolkit $argv &>/dev/null &; disown";
    };
  };


  programs.git = {
    enable = true;
    userName = "Mike";
    userEmail = "91095398+mkirl@users.noreply.github.com";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.helix = {
    enable = true;
    settings = {
      theme = "solarized_osaka";
      editor.cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
    };
    languages.language = [{
      name = "nix";
      auto-format = true;
      formatter.command = lib.getExe pkgs.nixfmt-rfc-style;
    }];
    themes = {
      autumn_night_transparent = {
        "inherits" = "autumn_night";
        "ui.background" = { };
      };
    };
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
    jetbrains.idea
    jetbrains.clion
    distrobox
    xwayland-satellite
    gcc
    btop
    fzf
    bat
    eza
    jq
  ];

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

  xdg.desktopEntries.discord = {
    name = "Discord";
    exec = "discord --enable-features=UseOzonePlatform --ozone-platform=wayland";
    icon = "discord";
    terminal = false;
    categories = [ "Network" "InstantMessaging" ];
  };

  home.stateVersion = "25.11";

}
