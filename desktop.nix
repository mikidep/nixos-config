{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./sway.nix
    ./cosmic.nix
  ];
  services.displayManager.gdm = {
    enable = true;
  };
}
