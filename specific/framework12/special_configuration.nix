{ config, pkgs, lib, ... }:

let
  niriRotationScript = pkgs.writeShellScript "niri-rotation" ''
    export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"
    export WAYLAND_DISPLAY="wayland-1"

    ${pkgs.iio-sensor-proxy}/bin/monitor-sensor 2>/dev/null | while IFS= read -r line; do
      case "$line" in
        *"normal"*)   ${pkgs.niri}/bin/niri msg output eDP-1 transform normal ;;
        *"bottom-up"*) ${pkgs.niri}/bin/niri msg output eDP-1 transform 180 ;;
        *"left-up"*)  ${pkgs.niri}/bin/niri msg output eDP-1 transform 90 ;;
        *"right-up"*) ${pkgs.niri}/bin/niri msg output eDP-1 transform 270 ;;
      esac
    done
  '';
in

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

  systemd.user.services.niri-rotation = {
    description = "Niri screen rotation via iio-sensor-proxy";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${niriRotationScript}";
      Restart = "on-failure";
      RestartSec = 2;
    };
  };

  services.logind = {
    settings = {
      Login = {
        HandleLidSwitch = "suspend";
        HandleLidSwitchExternalPower = "lock";
        HandlePowerKey = "suspend";
        HandlePowerKeyLongPress = "poweroff";
        PowerKeyIgnoreInhibited = "no";
        IdleAction = "ignore";
      };
    };
  };

  services.thermald.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 60;
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 0;
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";
      PCIE_ASPM_ON_AC = "default";
      PCIE_ASPM_ON_BAT = "powersupersave";
      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto";
      USB_AUTOSUSPEND = 1;
      USB_EXCLUDE_AUDIO = 1;
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";
      DISK_APM_LEVEL_ON_AC = "254";
      DISK_APM_LEVEL_ON_BAT = "128";
      DISK_IOSCHED = "";
      NMI_WATCHDOG = 0;
      RESTORE_DEVICE_STATE_ON_STARTUP = 0;
    };
  };

  services.fwupd.enable = true;

  environment.systemPackages = with pkgs; [
    awww
    iio-sensor-proxy
  ];
}
