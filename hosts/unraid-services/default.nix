{meta, ...}: {
  imports = [
    ../../modules/nixos
    ../../modules/services
    ./disko-config.nix
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = meta.hostname;
    networkmanager.enable = true;
  };

  # homelab.modules.services = {
  #   openssh.enable = true;
  #   blocky.enable = true;
  #   nginx.enable = true;
  #   owncloud.enable = true;
  #   paperless.enable = true;
  #   postgres.enable = true;
  # };

  services.qemuGuest.enable = true;

  sops.defaultSopsFile = ./secrets.yaml;

  # fileSystems = {
  #   "/mnt/data" = {
  #     device = "data";
  #     fsType = "virtiofs";
  #     options = [
  #       "nofail"
  #       "rw"
  #       "relatime"
  #     ];
  #   };
  # };
}
