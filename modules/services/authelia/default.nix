# inspired by https://codeberg.org/PopeRigby/config/src/branch/main/systems/x86_64-linux/haddock/services/auth/authelia.nix
{
  lib,
  getConfig,
  # getDataDir,
  # getAppDir,
  ...
}:
with lib; let
  name = "authelia";
  cfg = getConfig.${name};
in {
  options = {
    homelab.modules.services.${name} = {
      enable = mkEnableOption "Enable authelia";
      secrets = mkOption {
        type = types.attrs;
        default = {};
      };
      environmentVariables = mkOption {
        type = types.attrs;
        default = {};
      };
    };
  };

  config = mkIf cfg.enable {
    services.authelia.instances.rlyeh = {
      enable = true;
      settings = {
        theme = "auto";

        authentication_backend.ldap = {
          address = "ldap://localhost:3890";
          base_dn = "dc=cthyllaxy,dc=xyz";
          users_filter = "(&({username_attribute}={input})(objectClass=person))";
          groups_filter = "(member={dn})";
          user = "uid=authelia,ou=people,dc=cthyllaxy,dc=xyz";
        };

        access_control = {
          default_policy = "deny";
          # We want this rule to be low priority so it doesn't override the others
          rules = mkAfter [
            {
              domain = "*.cthyllaxy.xyz";
              policy = "one_factor";
            }
          ];
        };

        storage.postgres = {
          address = "unix:///run/postgresql";
          database = authelia;
          username = authelia;
        };

        session = {
          redis.host = "/var/run/redis-haddock/redis.sock";
          cookies = [
            {
              domain = "cthyllaxy.xyz";
              authelia_url = "https://auth.cthyllaxy.xyz";
              # The period of time the user can be inactive for before the session is destroyed
              inactivity = "1M";
              # The period of time before the cookie expires and the session is destroyed
              expiration = "3M";
              # The period of time before the cookie expires and the session is destroyed
              # when the remember me box is checked
              remember_me = "1y";
            }
          ];
        };

        # notifier.smtp = {
        #   address = "smtp://smtp.mailbox.org:587";
        #   username = "poperigby@mailbox.org";
        #   sender = "haddock@mailbox.org";
        # };

        log.level = "info";

        identity_providers.oidc = {
          # https://www.authelia.com/integration/openid-connect/openid-connect-1.0-claims/#restore-functionality-prior-to-claims-parameter
          claims_policies = {
            karakeep.id_token = ["email"];
            opkssh.id_token = ["email"];
          };

          cors = {
            endpoints = ["token"];
            allowed_origins_from_client_redirect_uris = true;
          };

          authorization_policies.default = {
            default_policy = "one_factor";
            rules = [
              {
                policy = "deny";
                subject = "group:lldap_strict_readonly";
              }
            ];
          };
        };

        webauthn = {
          enable_passkey_login = true;
        };

        # Necessary for Caddy integration
        # See https://www.authelia.com/integration/proxies/caddy/#implementation
        server.endpoints.authz.forward-auth.implementation = "ForwardAuth";
      };

      # Templates don't work correctly when parsed from Nix, so our OIDC clients are defined here
      settingsFiles = [./oidc_clients.yaml];

      secrets = cfg.secrets;

      environmentVariables = cfg.environmentVariables;
    };
  };
}
