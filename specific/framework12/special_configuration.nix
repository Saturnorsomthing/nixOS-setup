{ config, pkgs, lib, ... }:

{
  networking.hostName = "nixos";

  boot.initrd.kernelModules = [ "i915" "thunderbolt" ];
  boot.kernelParams = [ "mem_sleep_default=deep" "i915.enable_psr=1" ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
      intel-compute-runtime
      libGL
    ];
  };

  hardware.sensor.iio.enable = true;
  services.udev.packages = with pkgs; [ iio-sensor-proxy ];

  services.fwupd.enable = true;
  services.fprintd.enable = true;
  services.thermald.enable = true;

  systemd.user.services.niri-rotation = {
    description = "Niri Orientation Loop";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = pkgs.writeShellScript "niri-rotator" ''
        ${pkgs.coreutils}/bin/stdbuf -oL ${pkgs.iio-sensor-proxy}/bin/monitor-sensor | while read -r line; do
          case "$line" in
            *"normal"*)    ${pkgs.niri}/bin/niri msg output eDP-1 transform normal ;;
            *"bottom-up"*) ${pkgs.niri}/bin/niri msg output eDP-1 transform 180 ;;
            *"left-up"*)   ${pkgs.niri}/bin/niri msg output eDP-1 transform 90 ;;
            *"right-up"*)  ${pkgs.niri}/bin/niri msg output eDP-1 transform 270 ;;
          esac
        done
      '';
      Restart = "always";
      Environment = [ "WAYLAND_DISPLAY=wayland-0" ];
    };
  };

  environment.systemPackages = with pkgs; [
    awww
  ];

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = lib.mkForce "iHD";
    __GLX_VENDOR_LIBRARY_NAME = lib.mkForce "mesa";
  };
}
