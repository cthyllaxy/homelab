{
  lib,
  config,
  ...
}:
with lib; let
  name = "nix-serve";
  svcs = config.homelab.modules.services;
  cfg = svcs.${name};
in {
  options = {
    homelab.modules.services.${name} = {
      enable = mkEnableOption "Enable nix-serve";
      secretKeyFile = mkOption {
        type = types.str;
      };
    };
  };

  config = mkIf cfg.enable {
    services.${name} = {
      enable = true;
      secretKeyFile = cfg.secretKeyFile;
      openFirewall = true;
    };
  };
}
