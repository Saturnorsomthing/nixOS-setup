{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nautilus
    loupe
    celluloid
    kew
    neovim
    vesktop
    yt-dlp
    ffmpeg
    wineWow64Packages.full
    localsend
    libreoffice
    prismlauncher
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with vscode-extensions; [
        ms-python.python
        ms-python.debugpy
      ];
    })
    fastfetch
    onefetch
    rofi
    git
    yazi
    (python3.withPackages (ps: with ps; [
      debugpy
    ]))
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
    proton-vpn
    protonmail-desktop
    virt-viewer
    shared-mime-info
    ffmpegthumbnailer
    rot8
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    noto-fonts
  ];
}
