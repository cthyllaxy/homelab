{meta, ...}: {
  users.users.${meta.user} = {
    isNormalUser = true;
    extraGroups = ["wheel"];

    # created using mkpasswd
    initialHashedPassword = "$y$j9T$ZXh2Jt3R0ndY62DmlZCbG1$Sv5ZbyTe.2Q1vdv5UXYnLHPKv41hxKcikjKLYiVrzs4";
    openssh.authorizedKeys.keys = [
      # homelab shared key
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBAUwsFxF4kZQR1B9FFysiw2u0HqzyPqvwyDGs0+EJbm"
      # thamenato
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPNex73rFdYlEvOeU6YHtseNjSRb0jOJInomDPd3S6lP"
    ];
  };
}
