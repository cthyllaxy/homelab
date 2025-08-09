{
  lib,
  config,
  getConfig,
  getDataDir,
  ...
}:
with lib; let
  name = "immich";
  cfg = getConfig.${name};
in {
  options = {
    homelab.modules.services.${name} = {
      enable = mkEnableOption "Enable Immich";
    };
  };

  config = let
    mediaLocation = "${getDataDir}/${name}";
  in
    mkIf cfg.enable {
      services.immich = {
        enable = true;

        # networking
        openFirewall = true;

        # data
        mediaLocation = mediaLocation;

        # databases
        database.host = "/run/postgresql";
        redis.host = config.services.redis.servers.immich.unixSocket;

        accelerationDevices = ["/dev/dri/renderD128"];
      };

      # create the directory to store data
      systemd.tmpfiles.rules = [
        "d ${mediaLocation} 0750 immich immich - -"
      ];
    };
}
