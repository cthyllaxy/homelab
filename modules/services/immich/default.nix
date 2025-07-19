{
  lib,
  config,
  ...
}:
with lib; let
  svcs = config.homelab.modules.services;
  cfg = svcs.immich;
  name = "immich";
in {
  options = {
    homelab.modules.services.immich = {
      enable = mkEnableOption "Enable Immich";
    };
  };

  config = mkIf cfg.enable {
    services.immich = {
      enable = true;

      # networking
      openFirewall = true;

      # databases
      database.host = "/run/postgresql";
      redis.host = config.services.redis.servers.immich.unixSocket;

      # env vars
      secretsFile = "/run/secrets/immich";

      accelerationDevices = ["/dev/dri/renderD128"];
      mediaLocation = "${svcs.dataDir}/${name}";
    };
  };
}
