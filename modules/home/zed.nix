{ ... }: {
  flake.homeModules.zed = { ... }: {
    programs.zed-editor = {
      enable = true;
      # Symlinks the Nix-built remote_server binary into ~/.zed_server so
      # incoming SSH remote-dev connections (e.g. from the Mac/Asahi
      # machines) find a NixOS-compatible binary already in place instead
      # of downloading/running a generic dynamically-linked one that fails
      # on NixOS's non-FHS layout.
      installRemoteServer = true;
    };
  };
}
