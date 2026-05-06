{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./special_configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # Corrected nix settings to apply substituters properly
  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://attic.xuyh0120.win/lantian"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    ];
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "@wheel" ];
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v3;
  
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Vienna";
  services.timesyncd.enable = true;
  time.hardwareClockInLocalTime = false;

  services.flatpak.enable = true;
  services.gnome.gcr-ssh-agent.enable = false;
  programs.ssh.startAgent = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  programs.steam.enable = true;
  services.displayManager.gdm.enable = true;
  services.displayManager.gdm.wayland = true;
  programs.niri.enable = true;

  services.gvfs.enable = true;
  services.tumbler.enable = true;
  programs.fish.enable = true;

  users.users.saturn = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" ];
  };

  environment.systemPackages = with pkgs; [
    nautilus
    kew
    neovim
    discord
    yt-dlp
    ffmpeg
    wineWow64Packages.full     #wineWowPackages.full
    localsend
    libreoffice
    prismlauncher
    vscodium
    fastfetch
    onefetch
    rofi
    git
    yazi
    zig
    cmake
    lynx
    ninja
    python3
    ddcutil
    brightnessctl
    app2unit
    libcava
    glibc
    libqalculate
    upower
    bluez
    bluez-tools
    wf-recorder
    obs-studio
    gpu-screen-recorder
    gnome-keyring
    gcr
    impression
    galaxy-buds-client
    sassc
    optipng
    gtk4
    menulibre
    iio-sensor-proxy
    xournalpp
    xwayland-satellite
    proton-pass
    proton-vpn #protonvpn-gui
    protonmail-desktop
    virt-viewer
    shared-mime-info
    ffmpegthumbnailer
    rot8
    powertop
    auto-cpufreq
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    noto-fonts
  ];

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome pkgs.xdg-desktop-portal-gtk ];
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  system.stateVersion = "25.11";
}
