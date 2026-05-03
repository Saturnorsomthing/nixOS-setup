{ config, pkgs, ... }:

{
  networking.hostName = "nixos";

  services.xserver.videoDrivers = ["nvidia"];
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Enable the OpenRGB driver
  services.hardware.openrgb.enable = true;

  # Logic Service: Final Schedule
  systemd.services.rgb-logic = {
    description = "Sync RGB state (Final Schedule)";
    script = ''
      H=$(${pkgs.coreutils}/bin/date +"%H")
      
      # If hour is between 06:00 and 22:59 (Daytime), turn ON
      # If hour is 23:00 through 05:59 (Nighttime), turn OFF
      if [ "$H" -ge 06 ] && [ "$H" -lt 23 ]; then
        ${pkgs.openrgb}/bin/openrgb --mode static --color BDC3FF
      else
        ${pkgs.openrgb}/bin/openrgb --mode off
      fi
    '';
    serviceConfig.Type = "oneshot";
  };

  # Timer: Checking every minute to ensure state persistence
  systemd.timers.rgb-logic = {
    description = "Minute-by-minute RGB Enforcement";
    timerConfig = {
      OnCalendar = "*:0/1"; 
      Persistent = true;
    };
    wantedBy = [ "timers.target" ];
  };
}
