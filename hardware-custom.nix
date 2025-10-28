{
  lib,
  nixos-hardware,
  ...
}: {
  imports = [
    nixos-hardware.nixosModules.asus-zenbook-um6702
  ];
  hardware.nvidia.prime = {
    nvidiaBusId = lib.mkForce "PCI:1:0:0";
    amdgpuBusId = lib.mkForce "PCI:5:0:0";
  };
}
