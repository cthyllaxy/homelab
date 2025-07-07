_default:
    @just --list

# Fresh new install of NixOS in a host
bootstrap HOSTNAME IP USER='root':
    @nix run github:nix-community/nixos-anywhere -- \
        --generate-hardware-config nixos-generate-config './hosts/{{ HOSTNAME }}/hardware-configuration.nix' \
        --flake '.#{{ HOSTNAME }}' '{{ USER }}@{{ IP }}'

# Update a host remotely
update FLAKE USER IP:
    @nixos-rebuild switch --use-remote-sudo --fast \
        --flake .#{{ FLAKE }} \
        --target-host {{ USER }}@{{ IP }} \
        --build-host {{ USER }}@{{ IP }}

# Update host remotely using deploy-rs
deploy FLAKE:
    @deploy .#{{ FLAKE }}
