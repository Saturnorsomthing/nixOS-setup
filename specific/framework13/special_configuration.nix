{ config, pkgs, ... }:

{
  networking.hostName = "nixos";

  # AMD Specific Boot
  boot.kernelParams = [ "amd_pstate=active" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  
  # Graphics Drivers (Fixes Zig EGLInitFailed)
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      libGL
    ];
  };


  services.fwupd.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];
  
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  
  # Sensors
  hardware.sensor.iio.enable = true;
  services.udev.packages = with pkgs; [ iio-sensor-proxy ];
}
