{
  pkgs,
  lib,
  inputs,
  ...
}: let
  username = "leon";
in {
  users.users.leon = {
    isNormalUser = true;
    description = "leon";
    extraGroups = ["networkmanager" "wheel" "multimedia"];
    packages = with pkgs; [
      firefox
      kate
      chromium
      github-desktop
      fish
      steam
      gparted
      mplayer
      kmplayer
      # thunderbird
    ];
  };

  # Assuming this is part of your system's configuration
  systemd.timers.fstrim.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    acl
   # kio-admin
    wget
    git
    curl
    gvfs
    xfce.thunar
    kde-gtk-config
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-libav
    ffmpeg
    openssh
    age
    pinentry
    inputs.agenix.packages.${system}.default
    trufflehog
    helvum
    easyeffects

    # wine64
    #  vulkan-tools

    #  vulkan-validation-layers
    #  dxvk_2
    #  lutris
    #   nvidia-vaapi-driver
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
      "https://nix-gaming.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
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
   # lowLatency = {
      # enable this module
   #   enable = true;
      # defaults (no need to be set unless modified)
  #   quantum = 64;
   #   rate = 48000;
  #  };
  };

  boot.kernel.sysctl = {
    "vm.max_map_count" = 16777216;
    "fs.file-max" = 524288;
  };

  nix.gc = {
    automatic = true; # Enable automatic garbage collection
    dates = "weekly"; # Set the garbage collection frequency to weekly
    options = "--delete-older-than 14d"; # Remove generations older than 30 days
  };
}
