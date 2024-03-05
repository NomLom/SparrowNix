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
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
   # nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-citizen.url = "github:LovingMelody/nix-citizen";
    nix-citizen.inputs.nix-gaming.follows = "nix-gaming";
    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
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
    agenix,
    ...
  } @ inputs: let
    inherit (self) outputs;
    forAllSystems = nixpkgs.lib.genAttrs [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  in {
    # inherit nixpkgs;
    #  inherit nixpkgs-unstable;

    # Your custom packages and modifications, exported as overlays
    #overlays = import ./overlays {inherit inputs;};
    #user = "leon";

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

    nixosConfigurations = {
      slide-desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        #config.allowUnfree = true;
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/slide-desktop/default.nix
          agenix.nixosModules.default
          #  ({...}: {
          #    nixpkgs.overlays = [
          #      (final: prev: {
          #         # Add your unstable overlays :-)
          #          sonarr = inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.sonarr;
          #         })
          #        ];
          #       })
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager switch --flake .#leon@slide-desktop'
    # nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz home-manager
    # nix-channel --update
    homeConfigurations = {
      "leon@slide-desktop" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        #config.allowUnfree = true;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home-manager/home.nix
        ];
      };
    };
  };
}
