# the NixOS manual (accessible by running ‘nixos-help’).
# return to 23.11
# sudo nix-channel --add https://nixos.org/channels/nixos-23.11 nixos
# https://discourse.nixos.org/t/enable-plasma-6/40541
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/common.nix
    ../../modules/fonts.nix
    ../../modules/virtualisation.nix
    ../../modules/smartmon.nix
    ../../modules/plasma.nix
    ../../modules/starship.nix
   # ../../modules/passwordstore.nix
    # ../../modules/satpaper.nix
    ../../modules/nixos/services/default.nix
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    #inputs.nix-gaming.nixosModules.pipewireLowLatency

    #  "${inputs.nixpkgs-unstable}/nixos/modules/services/audio/navidrome.nix"
    # "${inputs.nixpkgs-unstable}/nixos/modules/services/misc/bazarr.nix"
    # "${inputs.nixpkgs-unstable}/nixos/modules/services/misc/jackett.nix"
    # "${inputs.nixpkgs-unstable}/nixos/modules/services/misc/radarr.nix"
    # "${inputs.nixpkgs-unstable}/nixos/modules/services/misc/sonarr.nix"
  ];

  disabledModules = [
    #   "services/audio/navidrome.nix"
    #  "services/misc/bazarr.nix"
    #  "services/misc/jackett.nix"
    #  "services/misc/radarr.nix"
    #  "services/misc/sonarr.nix"
  ];

  nixpkgs = {
    overlays = [
    ];
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix commands consistent with your flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  services.gnome.gnome-keyring.enable = true;
  programs.bash.enableCompletion = true;
  programs.nix-ld.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "slide-desktop";
  # networking.wireless.enable = true;
  # Enable networking
  networking.networkmanager.enable = true;

  # Enable discovery on local network by hostname.
  # https://github.com/NixOS/nixpkgs/issues/98050#issuecomment-1471678276
  services.resolved.enable = true;
  networking.networkmanager.connectionConfig."connection.mdns" = 2;
  services.avahi.enable = true;


  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
      libva
      vulkan-loader
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [libva];
    setLdLibraryPath = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.powerManagement.enable = false;
  hardware.nvidia.powerManagement.finegrained = false;
  hardware.nvidia.open = false;
  hardware.nvidia.nvidiaSettings = true;
  # Special config to load the latest (535 or 550) driver for the support of the 4070 SUPER
  hardware.nvidia.package = let
    rcu_patch = pkgs.fetchpatch {
      url = "https://github.com/gentoo/gentoo/raw/c64caf53/x11-drivers/nvidia-drivers/files/nvidia-drivers-470.223.02-gpl-pfn_valid.patch";
      hash = "sha256-eZiQQp2S/asE7MfGvfe6dA/kdCvek9SYa/FFGp24dVg=";
    };
  in
    config.boot.kernelPackages.nvidiaPackages.mkDriver {
      #  version = "535.154.05";
      #  sha256_64bit = "sha256-fpUGXKprgt6SYRDxSCemGXLrEsIA6GOinp+0eGbqqJg=";
      #  sha256_aarch64 = "sha256-G0/GiObf/BZMkzzET8HQjdIcvCSqB1uhsinro2HLK9k=";
      # openSha256 = "sha256-wvRdHguGLxS0mR06P5Qi++pDJBCF8pJ8hr4T8O6TJIo=";
      # settingsSha256 = "sha256-9wqoDEWY4I7weWW05F4igj1Gj9wjHsREFMztfEmqm10=";
      #  persistencedSha256 = "sha256-d0Q3Lk80JqkS1B54Mahu2yY/WocOqFFbZVBh+ToGhaE=";

      version = "550.40.07";
      sha256_64bit = "sha256-KYk2xye37v7ZW7h+uNJM/u8fNf7KyGTZjiaU03dJpK0=";
      sha256_aarch64 = "sha256-AV7KgRXYaQGBFl7zuRcfnTGr8rS5n13nGUIe3mJTXb4=";
      openSha256 = "sha256-mRUTEWVsbjq+psVe+kAT6MjyZuLkG2yRDxCMvDJRL1I=";
      settingsSha256 = "sha256-c30AQa4g4a1EHmaEu1yc05oqY01y+IusbBuq+P6rMCs=";
      persistencedSha256 = "sha256-11tLSY8uUIl4X/roNnxf5yS2PQvHvoNjnd2CB67e870=";

      patches = [rcu_patch];
    };

  #boot.initrd.kernelModules = [ "nvidia" ];
  #boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];

  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "leon";

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
