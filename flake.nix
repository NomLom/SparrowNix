{
  description = "Slides's NixOS Flake";

  nixConfig = {
    # substituers will be appended to the default substituters when fetching packages
    # nix com    extra-substituters = [munity's cache server
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gaming.url = "github:fufexan/nix-gaming";
    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    catppuccin-bat = {
      url = "github:catppuccin/bat";
      flake = false;
    };
    # Additional inputs...
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    sops-nix,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;
    systems = ["x86_64-linux" "aarch64-linux"];
    forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
    pkgsFor = lib.genAttrs systems (system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      });
  in rec {
    inherit nixpkgs;
    inherit nixpkgs-unstable;
    inherit lib;

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};
    #user = "leon";
    packages = forEachSystem (pkgs: import ./pkgs {inherit pkgs;});
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
    nixosConfigurations = {
      slide-desktop = nixpkgs.lib.nixosSystem rec {
        specialArgs = {inherit inputs;};
        system = "x86_64-linux";
        modules = [
          ({...}: {
            nixpkgs.overlays = [
              (final: prev: {
                # Add your unstable overlays :-)
                sonarr = inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.sonarr;
              })
            ];
          })
          ./hosts/slide-desktop
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager switch --flake .#leon@slide-desktop'
    # nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz home-manager
    # nix-channel --update
    homeConfigurations = {
      "leon@lide-desktop" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home-manager/home.nix
        ];
      };
    };
  };
}
