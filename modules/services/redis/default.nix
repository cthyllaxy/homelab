{
  lib,
  getConfig,
  ...
}:
with lib; let
  name = "redis";
  cfg = getConfig.${name};
in {
  options = {
    homelab.modules.services.${name} = {
      enable = mkEnableOption "Enable redis";
    };
  };

  config = mkIf cfg.enable {
    services.redis = {
      servers.services.enable = true;
    };
  };
}
