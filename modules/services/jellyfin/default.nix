{
  lib,
  config,
  ...
}:
with lib; let
  svcs = config.homelab.modules.services;
  cfg = svcs.jellyfin;
  name = "jellyfin";
in {
  options = {
    homelab.modules.services.jellyfin = {
      enable = mkEnableOption "Enable Jellyfin";
    };
  };

  config = mkIf cfg.enable {
    services.jellyfin = {
      enable = true;

      # networking
      openFirewall = true;

      # data
      configDir = "${svcs.appDir}/${name}";
      dataDir = "${svcs.dataDir}/${name}";
    };
  };
}
