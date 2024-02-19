{ config, lib, pkgs, options, ... }:




{

  services.radarr = {
    enable = true;
    dataDir = "/var/lib/radarr";
    user = "radarr";
    group = "radarr";
  };

  services.sonarr = {
    enable = true;
    dataDir = "/var/lib/sonarr";
    user = "sonarr";
    group = "sonarr";
  };


  services.jellyfin = {
    enable = true;

    user = "jellyfin";
    group = "jellyfin";
  };

  networking.firewall.allowedTCPPorts = [ 8096 8920 7878 8989 ]; # Add these to your

  # Optional: Configure users and groups for Radarr and Sonarr
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
