#
{
  config,
  inputs,
  lib,
  pkgs,
  options,
  ...
}: {
  system.activationScripts.setPermissions = {
    text = ''
      chown -R :multimedia /mnt/SSD/arr/ /mnt/media/media/
      chmod -R 775 /mnt/SSD/arr/ /mnt/media/media/
    '';
    deps = [];
  };

  users.groups.multimedia = {};
  services.radarr = {
    enable = true;
    dataDir = "/var/lib/radarr";
    user = "radarr";
    group = "multimedia";
  };

  services.sonarr = {
    enable = true;
    dataDir = "/var/lib/sonarr";
    user = "sonarr";
    group = "multimedia";
    package = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.sonarr;
  };

  services.jellyfin = {
    enable = true;

    user = "jellyfin";
    group = "multimedia";
  };

  networking.firewall.allowedTCPPorts = [8096 8920 7878 8989];
  # Configure config directorys
  users.users.radarr = {
    isSystemUser = true;
    home = "/var/lib/radarr";
    createHome = true;
  };

  users.users.sonarr = {
    isSystemUser = true;
    home = "/var/lib/sonarr";
    createHome = true;
  };

  users.users.jellyfin = {
    isSystemUser = true;
    home = "/var/lib/jellyfin";
    createHome = true;
  };
}
