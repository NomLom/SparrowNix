# slide-desktop-home.nix
{ pkgs, lib, inputs, ... }:
let
  commonConfig = import ../../home-manager/home.nix { inherit pkgs; };
  isGamingMachine = true; # Manually set flag for conditional logic
in
{
  imports = [ commonConfig ];

  # Machine-specific home-manager packages
  home.packages = with pkgs; lib.optionals isGamingMachine [
   # steam
    lutris
  ];
}
