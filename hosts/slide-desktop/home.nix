# home.nix
{ inputs, outputs, pkgs, lib, ... }:

{
  imports = [
  ../../home-manager/home.nix
  ../../modules/satpaper.nix
  ];

  # Machine-specific home-manager packages
  home.packages = with pkgs; [
   # steam
    lutris
    inputs.nix-citizen.packages.${system}.star-citizen

    #books
    calibre
    foliate
    bookworm
  ];
}
