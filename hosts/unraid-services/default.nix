{
  pkgs,
  meta,
  ...
}: {
  imports = [
    ../../modules/nixos
    ./disko-config.nix
    ./hardware-configuration.nix
  ];

  # sops = {
  #   defaultSopsFile = ../../../secrets/${meta.hostname}.yaml;
  #   defaultSopsFormat = "yaml";
  #   age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
  # };

  networking = {
    hostName = meta.hostname;
    networkmanager.enable = true;
  };

  # homelab.services = {
  #   blocky.enable = true;
  #   nginx.enable = true;
  #   openssh.enable = true;
  #   owncloud.enable = true;
  #   paperless.enable = true;
  #   postgres.enable = true;
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

  services.qemuGuest.enable = true;

  # allow user in group wheel to auth w/o passwd
  # this setting fixes nix-rebuild / deploy-rs issues
  # when building a new generation
  security.sudo.wheelNeedsPassword = false;

  # kernel version
  boot.kernelPackages = pkgs.linuxPackages_6_15;

  system.stateVersion = "25.05";
}
