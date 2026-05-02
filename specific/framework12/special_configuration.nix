{ config, pkgs, lib, ... }:

{
  networking.hostName = "nixos";

  # Hardware Support for Framework 13th Gen
  boot.initrd.kernelModules = [ "i915" "thunderbolt" ];
  boot.kernelParams = [ "mem_sleep_default=deep" "i915.enable_psr=1" ];
  services.fwupd.enable = true;

  # Sensors
  hardware.sensor.iio.enable = true;
  services.udev.packages = with pkgs; [ iio-sensor-proxy ];
  services.dbus.enable = true;

  # Automatic Rotation Service
  systemd.user.services.niri-rotation = {
    description = "Niri Orientation Loop";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    
    serviceConfig = {
      # This script maps monitor-sensor text directly to your working Niri commands
      ExecStart = pkgs.writeShellScript "niri-rotator" ''
        ${pkgs.iio-sensor-proxy}/bin/monitor-sensor | while read -r line; do
          if echo "$line" | grep -q "orientation changed"; then
            case "$line" in
              *"normal"*)    ${pkgs.niri}/bin/niri msg output eDP-1 transform normal ;;
              *"bottom-up"*) ${pkgs.niri}/bin/niri msg output eDP-1 transform 180 ;;
              *"left-up"*)   ${pkgs.niri}/bin/niri msg output eDP-1 transform 90 ;;
              *"right-up"*)  ${pkgs.niri}/bin/niri msg output eDP-1 transform 270 ;;
            esac
          fi
        done
      '';
      Restart = "always";
      RestartSec = 3;
      # We define these here so you don't have to add them to your Niri config
      Environment = [
        "WAYLAND_DISPLAY=wayland-0"
        "XDG_RUNTIME_DIR=/run/user/1000"
      ];
    };
  };

  # Graphics
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
      intel-compute-runtime
    ];
  };

  # Framework Sensor Calibration
  services.udev.extraHwdb = ''
    sensor:modalias:platform:cros-ec-accel*
     ACCEL_MOUNT_MATRIX=1,0,0;0,1,0;0,0,1
  '';

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = lib.mkForce "iHD";
  };
}
