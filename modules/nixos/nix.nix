{
  pkgs,
  meta,
  ...
}: {
  nix = {
    package = pkgs.nixVersions.latest;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      allowed-users = [meta.user];
      trusted-users = [meta.user];
    };
  };
}
