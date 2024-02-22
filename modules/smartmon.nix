 { config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.smartd;
  host = config.networking.hostName;

  smartdNotify = pkgs.writeScript "smartd-notify.sh" ''
    #! ${pkgs.runtimeShell}
    ${optionalString cfg.notifications.wall.enable ''
      echo "Problem detected with disk: $SMARTD_DEVICESTRING
      Warning message from smartd is:
      $SMARTD_MESSAGE" | ${pkgs.util-linux}/bin/wall
    ''}
    ${optionalString cfg.notifications.x11.enable ''
      export DISPLAY=${cfg.notifications.x11.display}
      echo "Problem detected with disk: $SMARTD_DEVICESTRING
      Warning message from smartd is:
      $SMARTD_FULLMESSAGE" | ${pkgs.xorg.xmessage}/bin/xmessage -file -
    ''}
  '';

in {

  options.services.smartd = {
    enable = mkEnableOption "smartd daemon from `smartmontools` package";

    notifications.wall = {
      enable = mkOption {
        default = true;
        type = types.bool;
        description = "Whether to send wall notifications to all users.";
      };
    };

    notifications.x11 = {
      enable = mkOption {
        default = config.services.xserver.enable;
        defaultText = "config.services.xserver.enable";
        type = types.bool;
        description = "Whether to send X11 xmessage notifications.";
      };

      display = mkOption {
        default = ":0";
        type = types.str;
        description = "DISPLAY to send X11 notifications to.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.smartd = {
      description = "S.M.A.R.T. Daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.smartmontools}/sbin/smartd --no-fork -M exec ${smartdNotify}";
      };
    };
  };

}
