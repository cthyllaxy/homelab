{ meta, pkgs, ... }:
{
  imports = [
    ./disko-config.nix
    ./hardware-configuration.nix
  ];

  networking.networkmanager.enable = true;
  networking.hostName = meta.hostname;

  services.qemuGuest.enable = true;
  # allow user in group wheel to auth w/o passwd
  # this setting fixes nix-rebuild / deploy-rs issues
  # when building a new generation
  security.sudo.wheelNeedsPassword = false;

  # kernel version
  boot.kernelPackages = pkgs.linuxPackages_6_11;

  system.stateVersion = "24.05";
}
