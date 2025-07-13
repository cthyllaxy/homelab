age_keys_path:="~/.config/sops/age"

_default:
    @just --list

# Fresh new install of NixOS in a host
bootstrap HOSTNAME IP USER='root':
    @nix run github:nix-community/nixos-anywhere -- \
        --generate-hardware-config nixos-generate-config './hosts/{{ HOSTNAME }}/hardware-configuration.nix' \
        --flake '.#{{ HOSTNAME }}' '{{ USER }}@{{ IP }}'

[group('sops')]
[private]
age-path:
    @mkdir -p {{ age_keys_path }}

[group('sops')]
bw-ssh-key: age-path
    @bw get item "Homelab SSH Sops Key" | \
        jq -r '.sshKey.privateKey' | \
        ssh-to-age -private-key > {{ age_keys_path }}/keys.txt

[group('sops')]
bw-age-key: age-path
    @bw get notes "Homelab Age Sops Key" > {{ age_keys_path }}/keys.txt

# Update a host remotely
update FLAKE USER IP:
    @nixos-rebuild switch --use-remote-sudo --fast \
        --flake .#{{ FLAKE }} \
        --target-host {{ USER }}@{{ IP }} \
        --build-host {{ USER }}@{{ IP }}

# Update host remotely using deploy-rs
deploy FLAKE:
    @deploy .#{{ FLAKE }}
