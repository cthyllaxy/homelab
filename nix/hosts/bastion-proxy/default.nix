{ config, ... }:
{
  imports = [
    ../../modules/services
    ../../modules/vm
  ];

  # Homelab Modules
  homelab.modules.services = {
    openssh.enable = true;
  };

  # Sops (Secrets)
  sops = {
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";

    secrets.cloudflaredCredentials = {
      owner = config.services.cloudflared.user;
    };
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
