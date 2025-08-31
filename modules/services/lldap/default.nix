{
  lib,
  config,
  getConfig,
  ...
}:
with lib; let
  name = "lldap";
  cfg = getConfig.${name};
in {
  options = {
    homelab.modules.services.${name} = {
      enable = mkEnableOption "Enable lldap";
      jwtSecretFile = mkOption {
        type = types.path;
      };
      keySeedFile = mkOption {
        type = types.path;
      };
      userPassFile = mkOption {
        type = types.path;
      };
    };
  };

  config = mkIf cfg.enable {
    # inspired by https://codeberg.org/PopeRigby/config/src/branch/main/systems/x86_64-linux/haddock/services/auth/lldap.nix
    users = {
      users.lldap = {
        group = "lldap";
        isSystemUser = true;
      };
      groups.lldap = {};
    };

    services.lldap = {
      enable = true;

      settings = {
        ldap_base_dn = "dc=cthyllaxy,dc=xyz";
        ldap_user_email = "admin@cthyllaxy.xyz";
        database_url = "postgresql://lldap@localhost/lldap?host=/run/postgresql";
        http_url = "https://lldap.cthyllaxy.xyz";
      };
      environment = {
        LLDAP_JWT_SECRET_FILE = cfg.jwtSecretFile;
        LLDAP_KEY_SEED_FILE = cfg.keySeedFile;
        LLDAP_LDAP_USER_PASS_FILE = cfg.userPassFile;
      };
    };

    services.postgresql = {
      ensureDatabases = [
        "lldap"
      ];
      ensureUsers = [
        {
          name = "lldap";
          ensureDBOwnership = true;
        }
      ];
    };

    systemd.services.lldap = let
      dependencies = [
        "postgresql.service"
      ];
    in {
      # LLDAP requires PostgreSQL to be running
      after = dependencies;
      requires = dependencies;
      # DynamicUser screws up sops-nix ownership because
      # the user doesn't exist outside of runtime.
      # serviceConfig.DynamicUser = lib.mkForce false;
    };

    networking.firewall = {
      allowedTCPPorts = [
        config.services.lldap.settings.ldap_port
        config.services.lldap.settings.http_port
      ];
    };
  };
}
