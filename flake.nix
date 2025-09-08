{
  description = "Homelab NixOS Flake";

  nixConfig = {
    extra-substituters = [
      "https://nix-cache.cthyllaxy.xyz"
      "https://nix-community.cachix.org"
      "https://colmena.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-cache.cthyllaxy.xyz:CEJYeiGUveq4GMALY2GHhcIwrr5PwYwdUj6skoHmBH8="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "colmena.cachix.org-1:7BzpDnjjH8ki2CT3f6GdOk7QAzPOl+1t3LvTLXqYcSg="
    ];
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    colmena.url = "github:zhaofengli/colmena";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    user = "cthulhu";
    utils = import ./utils;

    mkHost = hostName: (inputs.nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {
        meta = {
          inherit user utils;
        };
      };

      modules = [
        inputs.disko.nixosModules.disko
        inputs.sops-nix.nixosModules.sops
        ./modules
        ./hosts/${hostName}
      ];
    });

    hostsIPs = {
      unraid = "10.0.10.2";
      unraid-services = "10.0.10.10";
      unraid-vpn = "10.0.10.11";
      unraid-proxy = "10.0.10.12";
    };
  in {
    checks = {
      pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          check-added-large-files.enable = true;
          check-yaml.enable = true;
          deadnix.enable = true;
          detect-private-keys.enable = true;
          end-of-file-fixer.enable = true;
          alejandra.enable = true;
          trim-trailing-whitespace.enable = true;
        };
      };
    };

    devShells.${system}.default = pkgs.mkShell {
      inherit (self.checks.pre-commit-check) shellHook;

      buildInputs = [self.checks.pre-commit-check.enabledPackages];

      packages = with pkgs; [
        age
        alejandra
        bitwarden-cli
        copier
        fd
        inputs.colmena.packages.${system}.colmena
        just
        nil
        sops
        ssh-to-age
      ];
    };

    nixosConfigurations = {
      unraid-services = mkHost "unraid-services";
      unraid-vpn = mkHost "unraid-vpn";
      unraid-proxy = mkHost "unraid-proxy";
    };

    colmenaHive = let
      mkColmenaHost = hostName: {
        imports = [./hosts/${hostName}];

        deployment = {
          targetHost = hostsIPs."${hostName}";
          targetUser = user;
        };
      };
    in
      inputs.colmena.lib.makeHive {
        meta = {
          nixpkgs = import nixpkgs {inherit system;};

          specialArgs = {
            meta = {
              inherit user utils hostsIPs;
            };
          };
        };

        defaults = {
          imports = [
            inputs.disko.nixosModules.disko
            inputs.sops-nix.nixosModules.sops
            ./modules
          ];
          deployment.buildOnTarget = true;
        };

        unraid-services = mkColmenaHost "unraid-services";
        unraid-vpn = mkColmenaHost "unraid-vpn";
        unraid-proxy = mkColmenaHost "unraid-proxy";
      };
  };
}
