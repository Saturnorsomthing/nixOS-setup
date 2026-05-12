{ config, pkgs, ... }:

{
  networking.hostName = "nixos";

  boot.kernelParams = [ "amd_pstate=active" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      libGL
    ];
  };

  environment.systemPackages = with pkgs; [
    awww
  ];

  services.fwupd.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];
  
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
}
