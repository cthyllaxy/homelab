age_keys_path:="$HOME/.config/sops/age"
remote_user:="cthulhu"

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

# Create sops key using ssh key from bitwarden
[group('sops')]
bw-ssh-key: age-path
    @bw get item "Homelab SSH Sops Key" | \
        jq -r '.sshKey.privateKey' | \
        ssh-to-age -private-key > {{ age_keys_path }}/keys.txt

# Create sops key from existing one on bitwarden
[group('sops')]
bw-age-key: age-path
    @bw get notes "Homelab Age Sops Key" > {{ age_keys_path }}/keys.txt

# Update all sops files with new keys
[group('sops')]
update-keys:
    @fd -e "yaml" -p ./secrets | xargs sops updatekeys --yes

# Get age public key from host ssh key
[group('sops')]
get-age-from-host HOST:
    @ssh "{{ remote_user }}@{{ HOST }}" 'cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age'

# Update a host remotely
[group('deploy')]
nixos-rebuild FLAKE USER IP:
    @nixos-rebuild switch --use-remote-sudo --fast \
        --flake .#{{ FLAKE }} \
        --target-host {{ USER }}@{{ IP }} \
        --build-host {{ USER }}@{{ IP }}

# Update host remotely using colmena
[group('colmena')]
deploy NODES='*':
    @colmena apply \
        --parallel 1 \
        --on "{{ NODES }}"

[group('template')]
create-service SERVICE:
    @copier copy \
        -d "module_name={{SERVICE}}" \
        . "modules/services/{{SERVICE}}"
