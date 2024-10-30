{ pkgs, meta, ... }:
{
  nix = {
    package = pkgs.lix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      allowed-users = [ meta.user ];
      trusted-users = [ meta.user ];
    };
  };
}
