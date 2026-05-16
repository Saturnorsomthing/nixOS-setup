{ config, pkgs, lib, ... }:

{
  networking.hostName = "nixos";

  boot.kernelParams = [ "amd_pstate=active" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      libGL
      libva-vdpau-driver
      libvdpau-va-gl
      mesa
    ];
  };

  services.fprintd.enable = true;
  security.pam.services.login.fprintAuth = lib.mkForce true;
  security.pam.services.sudo.fprintAuth = lib.mkForce true;

  services.thermald.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "balanced";
      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto";
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";
      NMI_WATCHDOG = 0;
    };
  };

  services.fwupd.enable = true;

  environment.systemPackages = with pkgs; [
    awww
    libfprint
  ];
}
