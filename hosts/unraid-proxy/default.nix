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

          @foo host foo.cthyllaxy.xyz
          handle @foo {
            respond "Foo!"
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
