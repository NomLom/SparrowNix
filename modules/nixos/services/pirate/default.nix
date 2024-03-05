#
{
  config,
  inputs,
  lib,
  pkgs,
  options,
  ...
}: {
  users.groups.multimedia = {};
  services.radarr = {
    enable = true;
    dataDir = "/mnt/SSD/arr/config/radarr/";
    user = "radarr";
    group = "multimedia";
  #  package = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.radarr;
  };

  services.sonarr = {
    enable = true;
    dataDir = "/mnt/SSD/arr/config/sonarr/";
    user = "sonarr";
    group = "multimedia";
  #  package = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.sonarr;
  };

  services.jellyfin = {
    enable = true;

    user = "jellyfin";
    group = "multimedia";
  };

  networking.firewall.allowedTCPPorts = [ 8920 7878 8989];
  # Configure config directorys
  users.users.radarr = {
    isSystemUser = true;
    home = "/mnt/SSD/arr/config/radarr/";
    createHome = true;
  };

  users.users.sonarr = {
    isSystemUser = true;
    home = "/mnt/SSD/arr/config/sonarr/";
    createHome = true;
  };

  users.users.jellyfin = {
    isSystemUser = true;
    home = "/mnt/SSD/arr/config/jellyfin/";
    createHome = true;
  };

  system.activationScripts.setPermissions = {
    text = ''
      chown -R :multimedia /mnt/SSD/arr/ /mnt/media/media/
      chmod -R 775 /mnt/SSD/arr/ /mnt/media/media/
    /run/current-system/sw/bin/setfacl -Rm g:multimedia:rwx /mnt/SSD/arr/
    /run/current-system/sw/bin/setfacl -Rm g:multimedia:rwx /mnt/media/media/
    /run/current-system/sw/bin/setfacl -Rdm g:multimedia:rwx /mnt/SSD/arr/
    /run/current-system/sw/bin/setfacl -Rdm g:multimedia:rwx /mnt/media/media/
    '';
    deps = [];
  };
}
