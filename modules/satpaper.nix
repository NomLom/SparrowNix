{
  config,
  lib,
  pkgs,
  ...
}: let
  satpaperBinary = pkgs.stdenv.mkDerivation rec {
    pname = "satpaper";
    version = "0.6.0";
    src = pkgs.fetchurl {
      url = "https://github.com/Colonial-Dev/satpaper/releases/download/${version}/satpaper-x86_64-unknown-linux-musl";
      sha256 = "Z4Dc2/g7AcvLMme7dnnQgXPIrR9AImHXhqwWr2NHSNg=";
    };

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      install -Dm755 $src $out/bin/satpaper
    '';

    meta = {
      description = "Satpaper - dynamic wallpapers for your desktop";
      homepage = "https://github.com/Colonial-Dev/satpaper";
      license = pkgs.lib.licenses.mit;
    };
  };
in {
  systemd.user.services.satpaper = {
    Unit.Description = "Satpaper Dynamic Wallpaper Service";
    Install.WantedBy = ["default.target"];

    Service = {
      Environment = [
        "SATPAPER_SATELLITE=meteosat10"
        "SATPAPER_RESOLUTION_X=3840"
        "SATPAPER_RESOLUTION_Y=1600"
        "SATPAPER_DISK_SIZE=96"
        "SATPAPER_TARGET_PATH=${config.home.homeDirectory}/.local/share/backgrounds/"
      ];
      ExecStart = "${satpaperBinary}/bin/satpaper";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };

  # Optionally, add the satpaper binary to the user's environment
  #home.packages = [ satpaperBinary ];
}
