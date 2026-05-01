{ config, pkgs, ... }:

{
  networking.hostName = "nixos";

  # Hardware/Driver Specifics
  boot.kernelParams = [ "amd_pstate=active" ];
  boot.initrd.kernelModules = [ "amdgpu" "pinctrl_tigerlake" ];
  services.xserver.videoDrivers = [ "amdgpu" ];
  
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.sensor.iio.enable = true;
  services.udev.packages = with pkgs; [ iio-sensor-proxy ];
}
