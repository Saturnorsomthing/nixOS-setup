{ config, pkgs, lib, ... }:

{
  networking.hostName = "nixos";

  boot.initrd.kernelModules = [ "i915" "thunderbolt" ];
  boot.kernelParams = [ 
    "i915.enable_psr=1" 
    "i915.enable_fbc=1"
    "i915.enable_guc=3" 
    "mem_sleep_default=deep"
    "nvme.noacpi=1"
  ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
      libGL
    ];
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    SDL_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  hardware.sensor.iio.enable = true;

  systemd.user.services.rot8 = {
    description = "Screen Rotation Daemon";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.rot8}/bin/rot8 --sleep 800 --display eDP-1";
      Restart = "always";
    };
  };

  services.logind = {
    settings = {
      Login = {
        HandleLidSwitch = "suspend";
        HandleLidSwitchExternalPower = "lock";
      };
    };
  };

  services.thermald.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_MAX_PERF_ON_BAT = 60;
      PCIE_ASPM_ON_BAT = "powersupersave";
      USB_AUTOSUSPEND = 1;
    };
  };

  services.fwupd.enable = true;

  environment.systemPackages = with pkgs; [
    awww
    iio-sensor-proxy
    rot8
  ];
}
