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
        host = "10.0.10.10";

        # data
        mediaLocation = mediaLocation;

        # databases
        database.host = "/run/postgresql";
        redis.host = config.services.redis.servers.immich.unixSocket;

        accelerationDevices = ["/dev/dri/renderD128"];

        settings = {
          # references can be found at
          # https://immich.app/docs/install/config-file/
          externalDomain = "https://immich.cthyllaxy.xyz";
          storageTemplate = {
            enabled = true;
            hashVerificationEnabled = true;
            template = "{{y}}/{{MM}}/{{dd}}/{{filename}}";
          };
        };
      };

      # create the directory to store data
      systemd.tmpfiles.rules = [
        "d ${mediaLocation} 0750 immich immich - -"
      ];
    };
}
