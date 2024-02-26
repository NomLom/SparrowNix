{
  system,
  nixpkgs,
}: let
  overlayFiles = builtins.filter (name: builtins.match ".*\\.nix$" name != null) (builtins.readdir ./.);
  overlays = map (name: import (./. + "/${name}") {inherit system nixpkgs;}) overlayFiles;
in
  overlays
