{ meta, pkgs, ... }:
{
  imports = [
    ./boot.nix
    ./locale.nix
    ./nix.nix
    ./programs.nix
    ./users.nix
  ];

  # enable networking
  networking.networkmanager.enable = true;
  networking.hostName = meta.hostname;

  # kernel version
  boot.kernelPackages = pkgs.linuxPackages_6_11;

  system.stateVersion = "24.05";
}
