{
  lib,
  config,
  ...
}:
with lib; let
  name = "convos";
  svcs = config.homelab.modules.services;
  cfg = svcs.${name};
in {
  options = {
    homelab.modules.services.${name} = {
      enable = mkEnableOption "Enable Convos";
    };
  };

  config = mkIf cfg.enable {
    services.${name} = {
      enable = true;

      listenAddress = "*";
      reverseProxy = true;
    };

    networking.firewall = {
      allowedTCPPorts = [config.services.${name}.listenPort];
    };
  };
}
