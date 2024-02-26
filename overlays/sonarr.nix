{
  config,
  lib,
  pkgs,
  ...
}: let
  # Fetch the unstable nixpkgs
  unstablePkgs = import <nixpkgs-unstable> {
    config = config.nixpkgs.config;
  };
in {
  # Override the Sonarr package
  nixpkgs.overlays = [
    (self: super: {
      sonarr = unstablePkgs.sonarr;
    })
  ];
}
