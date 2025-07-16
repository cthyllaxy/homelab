{
  imports = [
    ./boot.nix
    ./locale.nix
    ./nix.nix
    ./services.nix
    ./system-packages.nix
    ./users.nix
  ];

  # allow user in group wheel to auth w/o passwd
  # this setting fixes nix-rebuild / deploy-rs issues
  # when building a new generation
  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "25.05";
}
