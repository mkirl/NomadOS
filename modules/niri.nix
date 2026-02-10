{ pkgs, ... }: {
  programs.niri.enable = true;
  programs.niri.package = pkgs.niri-unstable;

  services.xserver.xkb.options = "caps:escape";
}
