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
    ../../modules/plasma6.nix
    ../../modules/starship.nix
    ../../modules/nvidiaRTX.nix
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
  #services.printing.enable = true;

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

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "23.11"; # Did you read the comment?
}
