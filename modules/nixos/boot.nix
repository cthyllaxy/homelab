{pkgs, ...}: {
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    growPartition = true;

    # latest longterm ( https://kernel.org/ )
    kernelPackages = pkgs.linuxPackages_6_12;
  };
}
