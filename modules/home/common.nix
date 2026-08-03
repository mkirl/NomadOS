{ ... }: {
  flake.homeModules.common = { config, pkgs, lib, ... }: {
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
      settings.user.name = "Mike";
      settings.user.email = "91095398+mkirl@users.noreply.github.com";
    };

    programs.ghostty = {
      enable = true;
      # Package is installed per-host from the ghostty flake input (bleeding
      # edge) rather than nixpkgs; this block only manages its config file.
      package = null;
      systemd.enable = false;
      settings = {
        window-decoration = false;
        custom-shader = "${../../shaders/cursor_blaze.glsl}";
        background-opacity = 0.85;
        # Colors are generated from the wallpaper by noctalia at
        # ~/.config/ghostty/config-dankcolors; "?" makes the include a no-op
        # if noctalia hasn't written it yet. Loaded last, so it wins.
        config-file = "?config-dankcolors";
      };
    };

    programs.gh = {
      enable = true;
      settings.git_protocol = "ssh";
    };

    programs.ssh = {
      enable = true;
      matchBlocks."github.com" = {
        identityFile = "~/.ssh/github";
        identitiesOnly = true;
      };
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.starship = {
      enable = true;
      enableFishIntegration = true;
    };

    home.sessionVariables = {
      EDITOR = "nvim";
    };

    home.activation.lazyvim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -d "$HOME/.config/nvim" ]; then
        $DRY_RUN_CMD ${pkgs.git}/bin/git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
        $DRY_RUN_CMD rm -rf "$HOME/.config/nvim/.git"
      fi
    '';

    home.packages = with pkgs; [
      htop
      ripgrep
      fd
      tree
      neovim
      unzip
      lazygit
      nodejs
      wl-clipboard
      claude-code
      zellij
      fastfetch
      gcc
      btop
      fzf
      bat
      eza
      jq
      clang-tools
    ] ++ lib.optionals pkgs.stdenv.hostPlatform.isx86_64 [
      zed-editor
      solaar
      discord
      jetbrains.idea
      jetbrains.clion
      distrobox
      xwayland-satellite
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
          position = "left";
          thickness = 40;
          capsule = true;
          capsule_thickness = 0.85;
          capsule_padding = 6;
          background_opacity = 0.75;
          margin_edge = 8;
          margin_ends = 12;
          shadow = true;
          concave_edge_corners = true;
          font_weight = 500;
          widget_spacing = 6;
          icon_only = true;
          start = [ "launcher" "clipboard" ];
          center = [ "clock" "workspaces" ];
          end = [
            "cpu"
            "ram"
            "notifications"
            "network"
            "bluetooth"
            "volume"
            "battery"
            "session"
          ];
          capsule_group = [ "clock" "workspaces" ];
        };
        wallpaper.default = {
          enabled = true;
          path = "${../../wallpapers/topo2.png}";
        };
        widget.network = {
          show_label = false;
          vpn_status = "both";
          show_vpn_label = true;
        };
        widget.workspaces = { show_labels = false; };
        widget.cpu = {
          type = "sysmon";
          stat = "cpu_usage";
          visualization = "gauge";
          show_value = false;
        };
        widget.ram = {
          type = "sysmon";
          stat = "ram_used";
          visualization = "gauge";
          show_value = false;
        };
        widget.launcher = {
          custom_image = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg";
          custom_image_colorize = true;
        };
      };
    };

    home.pointerCursor = {
      enable = true;
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
  };
}
