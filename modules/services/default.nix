{
  lib,
  config,
  ...
}: let
  servicesPath = ./.;
in {
  # Read all directories from systemModules
  imports = builtins.filter (module: lib.pathIsDirectory module) (
    map (module: "${servicesPath}/${module}") (builtins.attrNames (builtins.readDir servicesPath))
  );

  _module.args = {
    getConfig = config.homelab.modules.services;
    getDataDir = "/mnt/data";
    getAppDir = "/mnt/appdata";
  };
}
