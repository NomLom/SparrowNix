{
  pkgs,
  lib,
  ...
}: let
  username = "leon";
in {
  users.users.leon = {
    isNormalUser = true;
    description = "leon";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      kate
      chromium
      github-desktop
      fish
      steam
      gparted

      # thunderbird
    ];
  };

  # Assuming this is part of your system's configuration
  systemd.timers.fstrim.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    curl
    gvfs
    xfce.thunar
    kde-gtk-config

    # Additional packages previously defined are merged here
  ];

  # Enable the systemd timer for periodic TRIM on SSDs.
  services.fstrim.enable = true;

  programs.steam.enable = true;
  programs.steam.remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  programs.steam.dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.thunar.enable = true;
  programs.xfconf.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  nix.settings = {
    trusted-users = ["leon"];
    substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true; # If you want to use JACK applications, uncomment this
  };
}
