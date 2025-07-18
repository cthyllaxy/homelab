{lib, ...}:
with lib; let
  servicesPath = ./.;
in {
  # Read all directories from systemModules
  imports = builtins.filter (module: lib.pathIsDirectory module) (
    map (module: "${servicesPath}/${module}") (builtins.attrNames (builtins.readDir servicesPath))
  );

  options = {
    homelab.modules.services.dataDir = mkOption {
      type = types.str;
      default = "/mnt/data";
      description = "Long term storage goes here";
    };
    homelab.modules.services.appDir = mkOption {
      type = types.str;
      default = "/mnt/appdata";
      description = "Cache/app data goes here";
    };
  };
}
