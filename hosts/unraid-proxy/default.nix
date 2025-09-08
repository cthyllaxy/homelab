{meta, ...}: {
  imports = [
    ./disko-config.nix
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "unraid-proxy";
    networkmanager.enable = true;
  };

  homelab.modules.services = {};

  # sops.defaultSopsFile = ./secrets.yaml;
  fileSystems = {
    "/mnt/acme" = meta.utils.mkUnraidShare "acme";
  };

  services.caddy = {
    enable = true;
    virtualHosts = {
      "*.cthyllaxy.xyz" = let
        certPath = "/mnt/acme/cthyllaxy.xyz/";
      in {
        extraConfig = ''
          encode gzip

          tls ${certPath}cert.pem ${certPath}key.pem

          @jellyfin host jellyfin.cthyllaxy.xyz
          handle @jellyfin {
            reverse_proxy http://${meta.hostsIPs.unraid-services}:8096
          }

          @nix-cache host nix-cache.cthyllaxy.xyz
          handle @nix-cache {
            reverse_proxy http://${meta.hostsIPs.unraid}:8501
          }

          @immich host immich.cthyllaxy.xyz
          handle @immich {
            reverse_proxy http://${meta.hostsIPs.unraid-services}:2283
          }

          @lldap host lldap.cthyllaxy.xyz
          handle @lldap {
            reverse_proxy http://${meta.hostsIPs.unraid-services}:17170
          }

          handle {
            abort
          }
        '';
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [
      80
      443
    ];
  };

  services.qemuGuest.enable = true;
}
