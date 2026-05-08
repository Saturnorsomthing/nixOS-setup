{ config, pkgs, lib, ... }:

{
  networking.hostName = "nixos-fw12";

  # Intel Specific Boot
  boot.initrd.kernelModules = [ "i915" "thunderbolt" ];
  boot.kernelParams = [ "mem_sleep_default=deep" "i915.enable_psr=1" ];

  # Graphics Drivers (Fixes Zig EGLInitFailed)
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
      intel-compute-runtime
      libGL
    ];
  };

  # Rotation & Sensors
  hardware.sensor.iio.enable = true;
  services.udev.packages = with pkgs; [ iio-sensor-proxy ];
  
  systemd.user.services.niri-rotation = {
    description = "Niri Orientation Loop";
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
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
      Environment = [ "WAYLAND_DISPLAY=wayland-0" "XDG_RUNTIME_DIR=/run/user/1000" ];
    };
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = lib.mkForce "iHD";
  };
}
