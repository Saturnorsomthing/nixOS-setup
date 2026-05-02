{ inputs, lib, pkgs, config, ... }:

{
  imports = [ ];

  xdg.configFile."gtk-4.0/gtk.css".force = true;
  xdg.configFile."gtk-4.0/settings.ini".force = true;
  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "Borealis-cursors";
    package = pkgs.borealis-cursors;
    size = 24;
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
      fastfetch
    '';
    plugins = [{ name = "tide"; src = pkgs.fishPlugins.tide.src; }];
  };

  programs.kitty = {
    enable = true;
    settings = {
      shell = "fish";
    };
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      codeberg = {
        host = "codeberg.org";
        hostname = "codeberg.org";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
      };
      github = { host = "github.com"; hostname = "github.com";
      user = "git"; identityFile = "~/.ssh/id_ed25519"; };
      "*" = {
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };
    };
    enableDefaultConfig = false;
  };

  programs.fuzzel.enable = true;
  programs.waybar.enable = true;
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
  };
  systemd.user.services.rot8 = {
    Unit.Description = "Screen rotation daemon";
    Service = {
      ExecStart = "${pkgs.rot8}/bin/rot8";
      Restart = "always";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  services.swaync.enable = true;

  home.packages = with pkgs; [
    inputs.zen-browser.packages."${pkgs.system}".default
    inputs.noctalia.packages."${pkgs.system}".default
    gcr
    swaybg
    rofi
    cliphist
    wl-clipboard
    wl-clip-persist
    wtype
    wl-screenrec
    wlr-randr
    nwg-displays
  ];
  home.stateVersion = "25.05";
}
