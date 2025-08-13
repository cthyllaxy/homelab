{
  pkgs,
  meta,
  ...
}: {
  nix = {
    package = pkgs.nixVersions.latest;
    settings = {
      substituters = [
        "https://nix-cache.cthyllaxy.xyz"
      ];
      trusted-public-keys = [
        "nix-cache.cthyllaxy.xyz:CEJYeiGUveq4GMALY2GHhcIwrr5PwYwdUj6skoHmBH8="
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      allowed-users = [meta.user];
      trusted-users = [meta.user];
    };

    gc = {
      # enable automatic garbage collection
      automatic = true;
      dates = "monthly";
      options = "--delete-older-than 60d";
    };

    # enable store optimization
    optimise = {
      automatic = true;
      dates = ["03:45"]; # daily at 3:45AM
    };
  };
}
