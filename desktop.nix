{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hyprland.nix
  ];
  services.displayManager.gdm = {
    enable = true;
  };

  # xdg.portal = {
  #   enable = true;
  #   extraPortals = with pkgs; [
  #     # xdg-desktop-portal-gtk
  #     xdg-desktop-portal-wlr
  #   ];
  #   config.common.default = "*";
  # };

  # greetd = {
  #   enable = true;
  #   settings = {
  #     default_session = {
  #       command = ''${lib.getExe pkgs.greetd.tuigreet} --time --asterisks --cmd sway'';
  #       user = "greeter";
  #     };
  #   };
  # };
}
