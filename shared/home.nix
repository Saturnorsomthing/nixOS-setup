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
    gtk4.theme = {
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
      background_opacity = "0.4";
     # background_blur = 1;
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
      github = { 
        host = "github.com"; 
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519"; 
      };
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

  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    extraConfig = {
      modi = "drun";
      show-icons = true;
      icon-theme = "Papirus-Dark";
      display-drun = ">";
      drun-display-format = "{icon} {name}";
      disable-history = false;
      sidebar-mode = false;
    };
    theme = let
      mkLiteral = value: { _type = "literal"; inherit value; };
    in {
      "*" = {
        bg = mkLiteral "#151515E6";
        fg = mkLiteral "#EFEFEF";
        accent = mkLiteral "#81A1C1";
        button = mkLiteral "#2E3440";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg";
        font = "DejaVuSansMono 11";
      };
      "window" = {
        width = mkLiteral "600px";
        background-color = mkLiteral "@bg";
        border = mkLiteral "2px";
        border-color = mkLiteral "@accent";
        border-radius = mkLiteral "12px";
      };
      "mainbox" = {
        padding = mkLiteral "12px";
        children = mkLiteral "[inputbar, listview]";
      };
      "inputbar" = {
        background-color = mkLiteral "@button";
        border-radius = mkLiteral "8px";
        padding = mkLiteral "8px";
        margin = mkLiteral "0 0 10px 0";
        children = mkLiteral "[prompt, entry]";
      };
      "prompt" = {
        padding = mkLiteral "0 10px 0 5px";
        text-color = mkLiteral "@accent";
      };
      "listview" = {
        lines = 12;
        columns = 1;
        fixed-height = false;
        scrollbar = false;
        spacing = mkLiteral "4px";
        cycle = true;
        dynamic = true;
        layout = mkLiteral "vertical";
      };
      "element" = {
        padding = mkLiteral "8px";
        border-radius = mkLiteral "6px";
        children = mkLiteral "[element-icon, element-text]";
      };
      "element selected" = {
        background-color = mkLiteral "@accent";
        text-color = mkLiteral "@button";
      };
      "element-icon" = {
        size = mkLiteral "24px";
        margin = mkLiteral "0 12px 0 0";
      };
      "element-text" = {
        vertical-align = mkLiteral "0.5";
      };
    };
  };

  home.packages = with pkgs; [
    inputs.zen-browser.packages."${stdenv.hostPlatform.system}".default
    inputs.noctalia.packages."${stdenv.hostPlatform.system}".default
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
