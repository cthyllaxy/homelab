{
  imports = [
    ./disko-config.nix
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "unraid-proxy";
    networkmanager.enable = true;
  };

  homelab.modules.services = {};

  services.qemuGuest.enable = true;

  # sops.defaultSopsFile = ./secrets.yaml;
}
