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

  config = let
    port = 3000;
  in
    mkIf cfg.enable {
      services.${name} = {
        enable = true;

        listenPort = port;
        listenAddress = "*";
      };

      networking.firewall = {
        allowedTCPPorts = [port];
        # allowedUDPPorts = [
        #   3000
        # ];
      };
    };
}
