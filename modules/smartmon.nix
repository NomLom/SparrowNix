{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.smartd;
  host = config.networking.hostName;

  smartdNotify = pkgs.writeScript "smartd-notify.sh" ''
    #! ${pkgs.runtimeShell}
    ${cfg.notifications.enable
      && cfg.notifications.wall.enable ''
        echo "Problem detected with disk: $SMARTD_DEVICESTRING
        Warning message from smartd is:
        $SMARTD_MESSAGE" | ${pkgs.util-linux}/bin/wall
      ''}
    ${cfg.notifications.enable
      && cfg.notifications.x11.enable ''
        ${pkgs.libnotify}/bin/notify-send "SMARTD Alert" "Problem detected with disk: $SMARTD_DEVICESTRING
        Warning message from smartd is:
        $SMARTD_FULLMESSAGE"
      ''}
  '';
in {
  options.services.smartd.notifications = {
    enable = mkEnableOption "Enable custom smartd notifications";

    wall = {
      enable = mkOption {
        default = true;
        type = types.bool;
        description = "Whether to send wall notifications to all users.";
      };
    };

    x11 = {
      enable = mkOption {
        default = true;
        type = types.bool;
        description = "Whether to send desktop notifications.";
      };

      display = mkOption {
        default = ":0";
        type = types.str;
        description = "DISPLAY for X11 notifications, not used for Wayland.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.smartd.serviceConfig.ExecStart = lib.mkForce "${pkgs.smartmontools}/sbin/smartd --no-fork -M exec ${smartdNotify}";
  };
}
