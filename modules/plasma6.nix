{
  config,
  pkgs,
  ...
}: {
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver = {
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;
   # desktopManager.plasma6.enable = true;
    displayManager.defaultSession = "plasmax11";
    xkb.layout = "gb";
    xkb.variant = "";
  };
  services.desktopManager.plasma6.enable = true;
  #programs.dconf.enable = true; g

  # Configure console keymap
  console.keyMap = "uk";
}
