# Homelab

Attempting to actually get the homelab up and running!

## Requirements

### Configuring SOPS

If running the repository from a new machine, it is required
to configure the `age` key (~/.config/sops/age/keys.txt).

There are two keys stored in Bitwarden - one is an `age` key
the other is an `ssh` key.

You can pick whichever by running:

```shell
just bw-ssh-key
# or
just bw-age-key
```

Then check if the keys.txt file is properly populated and
try to open any secret with `sops secrets/<name>.yaml`.

## Installing NixOS

This command is supposed to run once to set up the remote
host, anytime it runs against a machine, it'll format the
disks.

```shell
nix run github:nix-community/nixos-anywhere -- \
    --flake '.#unraid-nixos' <user>@<ip>
```

## Updating hosts remotely

### nixos-rebuild

```shell
nixos-rebuild switch --use-remote-sudo --fast \
    --flake .#unraid-nixos \
    --target-host <user>@<ip> \
    --build-host <user>@<ip>
```

### deploy-rs

```shell
deploy .#unraid-nixos
```
