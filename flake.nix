{
  description = "Homelab NixOS Flake";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://colmena.cachix.org"
    ];
    extra-trusted-public-keys = [
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
        fd
        inputs.colmena.packages.${system}.colmena
        just
        nil
        sops
        ssh-to-age
      ];
    };

    nixosConfigurations = {
      unraid-services = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          meta = {
            inherit user utils;
            hostname = "unraid-services";
          };
        };

        modules = [
          inputs.disko.nixosModules.disko
          inputs.sops-nix.nixosModules.sops
          ./modules
          ./hosts/unraid-services
        ];
      };
      unraid-vpn = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          meta = {
            inherit user utils;
            hostname = "unraid-vpn";
          };
        };

        modules = [
          inputs.disko.nixosModules.disko
          inputs.sops-nix.nixosModules.sops
          ./modules
          ./hosts/unraid-services
        ];
      };
    };

    colmenaHive = inputs.colmena.lib.makeHive {
      meta = {
        nixpkgs = import nixpkgs {inherit system;};

        nodeSpecialArgs = {
          unraid-services = {
            meta = {
              inherit user utils;
              hostname = "unraid-services";
            };
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

      unraid-services = {
        imports = [./hosts/unraid-services];

        deployment = {
          targetHost = "10.0.10.10";
          targetUser = user;
          tags = [
            "unraid"
            "vm"
          ];
        };
      };
      unraid-vpn = {
        imports = [./hosts/unraid-services];

        deployment = {
          targetHost = "10.0.10.11";
          targetUser = user;
          tags = [
            "unraid"
            "vm"
          ];
        };
      };
    };
  };
}
