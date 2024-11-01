{
  imports = [
    ./disko-config.nix
    ./hardware-configuration.nix
  ];

  # qemuGuest service
  services.qemuGuest.enable = true;
  # make sure it's ssh is always there
  services.openssh.enable = true;

  # allow user in group wheel to auth w/o passwd
  # this setting fixes nix-rebuild / deploy-rs issues
  # when building a new generation
  security.sudo.wheelNeedsPassword = false;
}
