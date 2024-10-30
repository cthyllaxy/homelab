{ config, ... }:
{
  imports = [ ../../modules ];

  sops = {
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";
  };

  homelab.modules.services = {
    openssh.enable = true;
  };

  sops.secrets.cloudflaredCredentials = {
    owner = "cloudflared";
  };

  services.cloudflared = {
    enable = true;

    tunnels = {
      Rlyeh = {
        default = "http_status:404";
        credentialsFile = "${config.sops.secrets.cloudflaredCredentials.path}";
      };
    };
  };
}
