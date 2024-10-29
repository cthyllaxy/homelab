{
  config,
  lib,
  pkgs,
  meta,
  ...
}:

with lib;

let
  cfg = config.homelab.modules.nix;
in
{
  options = {
    homelab.modules.nix.enable = mkEnableOption "Nix configurations";
  };

  config = mkIf cfg.enable {
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
  };
}
