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
    extraGroups = ["networkmanager" "wheel" "multimedia" "kvm" "libvirtd"];
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
    autojump
    xfce.thunar
    kde-gtk-config
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-libav
    #libnvcuvid1
    #libnvidia-encode1
    ffmpeg
    openssh
    age

    inputs.agenix.packages.${system}.default
    trufflehog
    helvum
    easyeffects
    curseradio
    cava
    flameshot
    flatpak
    feh
    powershell
    kitty
    gparted
    mangohud
    protonup-ng
    python3Full
    #python.pkgs.pip
    qemu
    ripgrep
    #rofi
    steam
    steam-run



    vkd3d
    dxvk_2

    # Hardware info
       clinfo
       fwupd
      glxinfo
    ##   gsmartcontrol
       hwinfo
       usbutils
       pciutils
    #  smartmontools
      vulkan-tools

    # GUI DE tools
    #  gnome.gnome-disk-utility # this will break plasma 6 display manager
    #  kate
    #  kcharselect
    #  libsForQt5.kcalc
    #  libsForQt5.kdeconnect-kde
    #  libsForQt5.plasma-disks
    #  pavucontrol

    # Feel and look
    #  papirus-icon-theme
    #  qogir-kde
    #  qogir-theme
    #  qogir-icon-theme

    # Internet
    #  akregator
    # signal-desktop

    # Media
    #   audacious
    #   ffmpeg
    #   freetube
    #   kid3
    #   mpv
    #   shortwave

    #  vlc

    # Graphics
    #   krita
    #   pinta

    # Development
    notepadqq
    #  vscodium

    # Office
    #    freeoffice
    #   hunspell
    #   joplin-desktop
    #  keepassxc
    #  libreoffice-qt
    #   standardnotes

    # Emulators
    # fsuae
    # fsuae-launcher

    # File Tools
    #  doublecmd
    #veracrypt

    # Backup, sync
    #  backintime
    #  grsync
    #nextcloud-client

    # wine64
    #  vulkan-tools

    #  vulkan-validation-layers
    #  dxvk_2
    #  lutris
    #   nvidia-vaapi-driver
    # Additional packages previously defined are merged here
  ];

  services.flatpak.enable = true;
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
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
}
