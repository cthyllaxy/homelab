_default:
    @just --list

# Fresh new install of NixOS in a host
install FLAKE USER IP:
    @nix run github:nix-community/nixos-anywhere -- \
        --flake '.#{{ FLAKE }}' {{ USER }}@{{ IP }}

# Update a host remotely
update FLAKE USER IP:
    @nixos-rebuild switch --use-remote-sudo --fast \
        --flake .#{{ FLAKE }} \
        --target-host {{ USER }}@{{ IP }} \
        --build-host {{ USER }}@{{ IP }}

get-host-sops IP:
    @ssh {{ IP }} -t \
        -o RemoteCommand='nix shell nixpkgs#ssh-to-age --command ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub' | \
        tail -n 1

update-sops-keys:
    @find {{ justfile_directory() }} -type f -name "secrets.yaml" | xargs sops updatekeys -y

# Update host remotely using colmena
deploy *args='--help':
    @-colmena "{{args}}"
