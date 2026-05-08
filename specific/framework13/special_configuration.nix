{ config, pkgs, ... }:

{
  networking.hostName = "nixos-fw13";

  # AMD Specific Boot
  boot.kernelParams = [ "amd_pstate=active" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  
  # Graphics Drivers (Fixes Zig EGLInitFailed)
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      amdvlk
      libGL
    ];
  };

  services.xserver.videoDrivers = [ "amdgpu" ];
  
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  
  # Sensors
  hardware.sensor.iio.enable = true;
  services.udev.packages = with pkgs; [ iio-sensor-proxy ];
}
