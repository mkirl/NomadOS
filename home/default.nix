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
      theme = "gruvbox";
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
    clang-tools
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

  programs.noctalia = {
    enable = true;
    settings = {
      theme = {
        mode = "dark";
        source = "wallpaper";
        wallpaper_scheme = "m3-content";
      };
      bar.default = {
        position = "top";
        thickness = 40;
        capsule = true;
        capsule_thickness = 0.8;
        capsule_padding = 8;
        background_opacity = 0.9;
        margin_edge = 6;
        margin_ends = 6;
        shadow = true;
        concave_edge_corners = true;
        font_weight = 500;
        widget_spacing = 4;
        start = [ "launcher" "workspaces" "cpu" "ram" "gpu" "network_rx" "network_tx" ];
        center = [ "clock" "notifications" ];
        end = [
          "network"
          "bluetooth"
          "volume"
          "brightness"
          "battery"
          "session"
        ];
      };
      wallpaper.default = {
        enabled = true;
        path = "${../wallpapers/topo2.png}";
      };
      widget.network = {
        show_name = false;
      };
    };
  };

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };

  home.stateVersion = "25.11";

}
