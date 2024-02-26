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
    catppuccin-bat = {
      url = "github:catppuccin/bat";
      flake = false;
    };
    # Additional inputs...
  };


  outputs = {self, nixpkgs, ...}@inputs: {


    #user = "leon";
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

          # make home-manager as a module of nixos
          # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.users.leon = import ./home-manager/home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
        ];

      };
    };
  };
}
