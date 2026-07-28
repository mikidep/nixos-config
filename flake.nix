{
  description = "NixOS config flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    musnix,
    nixos-hardware,
    ...
  }: let
    system = "x86_64-linux";
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit system;
        inherit nixos-hardware;
      };
      modules = [
        musnix.nixosModules.musnix
        ./configuration.nix
      ];
    };
  };
}
