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
    ../../modules/system.nix
    ../../modules/fonts.nix
    ../../modules/virtualisation.nix
    ../../modules/smartmon.nix
    ../../modules/plasma.nix
    ../../modules/starship.nix
    ../../modules/passwordstore.nix
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
      # NOTE (2024-01-21): The substituter logic currently has a bug that is being worked on
      # https://github.com/NixOS/nix/issues/6901
      # https://github.com/NixOS/nix/pull/8983
      # substituters = ["http://rpi.local"];
    };
  };

  services.gnome.gnome-keyring.enable = true;

  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "gtk2";
    enableSSHSupport = true;
  };

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

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # GPU
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    nvidiaSettings = true;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.latest;# stable, production, latest, beta, or vulkan_beta
  };
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [libva];
    setLdLibraryPath = true;
  };
  services.xserver.videoDrivers = ["nvidia"];


  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];

  # use the example session manager (no others are packaged yet so this is enabled by default,
  # no need to redefine it in your config for now)
  #media-session.enable = true;
  #};

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.

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
