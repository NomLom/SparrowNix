 { config, pkgs, ... }:

let
  user = "leon"; # Adjust to the target user
  satpaperBin = "${pkgs.stdenv.mkDerivation {
    name = "satpaper";
    buildInputs = [ pkgs.cargo pkgs.rustc pkgs.git ];
    src = pkgs.fetchFromGitHub {
      owner = "Colonial-Dev";
      repo = "satpaper";
      rev = "master"; # You might want to pin this to a specific commit for stability
      sha256 = "18bd983255f2d158ed4cedb03548c5cb4babfcb0"; # Fill in the correct sha256
    };
    buildPhase = ''
      cargo build --release
    '';
    installPhase = ''
      mkdir -p $out/bin
      cp target/release/satpaper $out/bin/
    '';
  }}";
in
{

  systemd.user.services.satpaper = {
    description = "Satpaper Dynamic Wallpaper Service";
    path = [ pkgs.git ];
    environment = {
      SATPAPER_SATELLITE = "goes-east";
      SATPAPER_RESOLUTION_X = "2560";
      SATPAPER_RESOLUTION_Y = "1440";
      SATPAPER_DISK_SIZE = "94";
      SATPAPER_TARGET_PATH = "/home/${user}/.local/share/backgrounds/";
    };
    script = "${satpaperBin}/bin/satpaper";
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "5";
    };
    wantedBy = [ "default.target" ];
  };

  # Enable the service for the user
  systemd.user.services.satpaper.enable = true;
}
