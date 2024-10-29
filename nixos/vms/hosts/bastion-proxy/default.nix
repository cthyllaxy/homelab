{ config, ... }:
{
  imports = [
    ../../defaults
    ./services
  ];

  sops = {
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";
  };

  modules.services = {
    caddy.enable = false;
  };

  sops.secrets.cloudflaredCredentials = {
    owner = "cloudflared";
  };

  # sops.secrets.cloudflaredCert = {
  #   owner = "cloudflared";
  # };

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
