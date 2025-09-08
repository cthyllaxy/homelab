{
  meta,
  config,
  ...
}: {
  imports = [
    ./disko-config.nix
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "unraid-services";
    networkmanager.enable = true;
  };

  homelab.modules.services = {
    jellyfin.enable = true;
    postgres.enable = true;
    immich.enable = true;
    lldap = {
      enable = true;

      jwtSecretFile = config.sops.secrets."lldap/jwt_secret".path;
      keySeedFile = config.sops.secrets."lldap/key_seed".path;
      userPassFile = config.sops.secrets."lldap/admin_password".path;
    };
    # paperless.enable = true;
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "acme@cthyllaxy.xyz";
      environmentFile = config.sops.secrets.acme.path;
    };

    certs."cthyllaxy.xyz" = {
      domain = "*.cthyllaxy.xyz";
      dnsProvider = "cloudflare";

      # move cert files to host folder
      postRun = let
        out = "/mnt/data/acme/cthyllaxy.xyz";
      in ''
        mkdir -p ${out}
        cp *.pem ${out}/
      '';
    };
  };

  services.qemuGuest.enable = true;

  sops = {
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      acme = {};
      "lldap/jwt_secret".owner = "lldap";
      "lldap/key_seed".owner = "lldap";
      "lldap/admin_password".owner = "lldap";
    };
  };

  fileSystems = {
    "/mnt/data" = meta.utils.mkUnraidShare "data";
    "/mnt/appdata" = meta.utils.mkUnraidShare "appdata";
  };
}
