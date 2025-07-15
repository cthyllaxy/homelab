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

  homelab.modules.services = {
    openssh.enable = true;
    # blocky.enable = true;
    # nginx.enable = true;
    # owncloud.enable = true;
    # paperless.enable = true;
    # postgres.enable = true;
  };

  services = {
    qemuGuest.enable = true;
  };

  # sops = {
  #   defaultSopsFile = ../../../secrets/${meta.hostname}.yaml;
  #   defaultSopsFormat = "yaml";
  #   age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
  # };

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
