# Usenet binary client.
{ config, lib, ... }:

{
   # Enable the SABnzbd service
  services.sabnzbd = {
    enable = true;
    # Specify the user and group under which SABnzbd will run
    user = "sabnzbd";
    group = "sabnzbd";
    # For custom configurations, you can specify the configuration file path
    # configFile = "/path/to/your/sabnzbd.ini";
  };

  # Configure the user for SABnzbd (if not already existing)
  users.users.sabnzbd = {
    isSystemUser = true;
    group = "sabnzbd";
    home = lib.mkForce "/var/lib/sabnzbd"; # Force the use of this home directory
    createHome = true;
  };

  # Ensure the SABnzbd group exists
  users.groups.sabnzbd = {};

  # Open firewall ports if necessary
  networking.firewall.allowedTCPPorts = [ 8080 ]; # Default SABnzbd web interface port
}
