{meta, ...}: {
  users.users.${meta.user} = {
    isNormalUser = true;
    extraGroups = ["wheel"];

    # created using mkpasswd
    # hashedPassword = "$6$U/Gk7/zD4uUWVGzJ$CJ6ZKPLpBCUUVzmwsRlv2csJbIuChM8pf1mlRIdazdQBvQyCS3uukcKwH0t20WqJKmDOdQB2N5.qc5TYbKwn01";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBAUwsFxF4kZQR1B9FFysiw2u0HqzyPqvwyDGs0+EJbm"
    ];
  };
}
