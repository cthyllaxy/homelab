{
  lib,
  getConfig,
  getDataDir,
  getAppDir,
  ...
}:
with lib; let
  name = "jellyfin";
  cfg = getConfig.${name};
in {
  options = {
    homelab.modules.services.${name} = {
      enable = mkEnableOption "Enable Jellyfin";
    };
  };

  config = mkIf cfg.enable {
    services.jellyfin = {
      enable = true;

      # networking
      openFirewall = true;

      # data
      configDir = "${getAppDir}/${name}";
      dataDir = "${getDataDir}/${name}";
    };
  };
}
