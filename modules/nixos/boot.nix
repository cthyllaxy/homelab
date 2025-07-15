{pkgs, ...}: {
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    growPartition = true;

    kernelPackages = pkgs.linuxPackages_6_15;
  };
}
