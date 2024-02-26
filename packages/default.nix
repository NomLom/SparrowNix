{ pkgs ? import <nixpkgs> { } }: rec {

nix-inspect = pkgs.callPackage ./nix-inspect { };

}
