{
  lib,
  pkgs,
  getConfig,
  getDataDir,
  ...
}:
with lib; let
  name = "postgres";
  cfg = getConfig.${name};
in {
  options = {
    homelab.modules.services.${name} = {
      enable = mkEnableOption "Enable Postgres Configs";
      dataDir = mkOption {
        type = types.str;
        default = "${getDataDir}/postgres";
        description = "Path to store PostgreSQL data";
      };
    };
  };

  config = mkIf cfg.enable {
    services.postgresql = {
      enable = true;
      package = pkgs.postgresql_16;
      dataDir = cfg.dataDir;
    };

    # create the directory with correct permissions
    # it doesn't create folders other than the default value
    # defined for `dataDir`
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0750 postgres postgres - -"
    ];
  };
}
