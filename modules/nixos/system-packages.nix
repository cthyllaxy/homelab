{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    btop
    git
    neovim
    ssh-to-age
  ];
}
