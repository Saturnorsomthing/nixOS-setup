{ config, pkgs, ... }:

{
  networking.hostName = "nixos";

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics.enable = true;
  
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
  };

  boot.kernelParams = [ 
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1" 
    "nvidia.NVreg_TemporaryFilePath=/var/tmp"
  ];

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_DRM_NO_ATOMIC = "1";
  };

  services.hardware.openrgb.enable = true;
  
  systemd.services.rgb-logic = {
    description = "Sync RGB state (Final Schedule)";
    script = ''
      H=$(${pkgs.coreutils}/bin/date +"%H")
      
      if [ "$H" -ge 06 ] && [ "$H" -lt 23 ];
      then
        ${pkgs.openrgb}/bin/openrgb --mode static --color BDC3FF
      else
        ${pkgs.openrgb}/bin/openrgb --mode off
      fi
    '';
    serviceConfig.Type = "oneshot";
  };

  systemd.timers.rgb-logic = {
    description = "Minute-by-minute RGB Enforcement";
    timerConfig = {
      OnCalendar = "*:0/1"; 
      Persistent = true;
    };
    wantedBy = [ "timers.target" ];
  };
}
