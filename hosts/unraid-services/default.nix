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
    hostName = meta.hostname;
    networkmanager.enable = true;
  };

  homelab.modules.services = {
    jellyfin.enable = true;
    # openssh.enable = true;
    # blocky.enable = true;
    # nginx.enable = true;
    # owncloud.enable = true;
    # paperless.enable = true;
    # postgres.enable = true;
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
    };
  };

  fileSystems = {
    "/mnt/data" = meta.utils.mkUnraidShare "data";
    "/mnt/appdata" = meta.utils.mkUnraidShare "appdata";
  };
}
