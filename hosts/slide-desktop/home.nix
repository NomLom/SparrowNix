{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/satpaper.nix
  ];

  # Rest of your Home Manager configurations...
}
