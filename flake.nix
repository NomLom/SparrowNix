{
  description = "Slide's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin-bat = {
      url = "github:catppuccin/bat";
      flake = false;
    };
    # Additional inputs...
  };

outputs = { self, nixpkgs, home-manager, nixpkgs-unstable, flake-utils,... } @ inputs: {
  nixosConfigurations.slide-desktop = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./hosts/slide-desktop/default.nix
      {
        nixpkgs.overlays = import ./overlays {
          inherit (inputs) nixpkgs;
        };
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.leon = import ./home-manager/home.nix;
        # Optionally, include other configurations or overlays here
      }
      # Include additional modules if necessary
    ];
  };
};

}
