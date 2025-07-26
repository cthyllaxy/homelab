{meta, ...}: {
  imports = [
    ./disko-config.nix
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "unraid-vpn";
    networkmanager.enable = true;
  };

  homelab.modules.services = {
    convos.enable = true;
    # openssh.enable = true;
    # blocky.enable = true;
    # nginx.enable = true;
    # owncloud.enable = true;
    # paperless.enable = true;
    # postgres.enable = true;
  };

  services.qemuGuest.enable = true;

  sops.defaultSopsFile = ./secrets.yaml;

  fileSystems = {
    "/mnt/data" = meta.utils.mkUnraidShare "data";
    "/mnt/appdata" = meta.utils.mkUnraidShare "appdata";
  };
}
