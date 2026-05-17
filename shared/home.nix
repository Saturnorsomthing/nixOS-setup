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
        bg       = mkLiteral "#151515";
        fg       = mkLiteral "#EFEFEF";
        accent   = mkLiteral "#B4BEFE";
        button   = mkLiteral "#2E3440";
        hdr      = mkLiteral "#1a1a2e";
        dim      = mkLiteral "#6272a4";
        hdrbdr   = mkLiteral "#2a2a3e";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg";
        font = "FiraCode Nerd Font 11";
      };
      "window" = {
        width = mkLiteral "620px";
        background-color = mkLiteral "@bg";
        border = mkLiteral "2px";
        border-color = mkLiteral "@accent";
        border-radius = mkLiteral "12px";
      };
      "mainbox" = {
        padding = mkLiteral "0px";
        spacing = mkLiteral "0px";
        children = mkLiteral "[header, inputbar, separator, listview, footer]";
      };
      "header" = {
        background-color = mkLiteral "@hdr";
        padding = mkLiteral "8px 14px";
        border = mkLiteral "0 0 1px 0";
        border-color = mkLiteral "@hdrbdr";
        border-radius = mkLiteral "10px 10px 0 0";
        expand = false;
        orientation = mkLiteral "horizontal";
        children = mkLiteral "[textbox-left, textbox-right]";
      };
      "textbox-left" = {
        expand = true;
        str = "NixOS ${lib.trivial.release} (${lib.trivial.codeName}) ${pkgs.stdenv.hostPlatform.uname.processor}"; # me when i overcomplicate things :troll:
        text-color = mkLiteral "@accent";
        background-color = mkLiteral "transparent";
        font = "FiraCode Nerd Font 11";
        vertical-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.0";
      };
      "textbox-right" = {
        expand = false;
        str = "ROFI";
        text-color = mkLiteral "@dim";
        background-color = mkLiteral "transparent";
        font = "FiraCode Nerd Font 11";
        vertical-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "1.0";
      };
      "inputbar" = {
        background-color = mkLiteral "@button";
        border-radius = mkLiteral "8px";
        padding = mkLiteral "8px 12px";
        margin = mkLiteral "10px 12px 0";
        spacing = mkLiteral "0px";
        children = mkLiteral "[prompt, entry]";
        border = mkLiteral "1px";
        border-color = mkLiteral "#3a3f4b";
      };
      "prompt" = {
        padding = mkLiteral "0 10px 0 2px";
        text-color = mkLiteral "@accent";
      };
      "entry" = {
        text-color = mkLiteral "@fg";
      };
      "separator" = {
        background-color = mkLiteral "@button";
        height = mkLiteral "1px";
        margin = mkLiteral "6px 12px 4px";
        expand = false;
      };
      "listview" = {
        lines = 10;
        columns = 1;
        fixed-height = false;
        scrollbar = false;
        spacing = mkLiteral "2px";
        cycle = true;
        dynamic = true;
        layout = mkLiteral "vertical";
        padding = mkLiteral "4px 12px 6px";
      };
      "element" = {
        padding = mkLiteral "7px 10px";
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
      "footer" = {
        background-color = mkLiteral "transparent";
        padding = mkLiteral "7px 14px";
        spacing = mkLiteral "0px";
        expand = false;
        border = mkLiteral "1px 0 0 0";
        border-color = mkLiteral "@button";
        children = mkLiteral "[textbox-footer]";
      };
      "textbox-footer" = {
        expand = true;
        str = "↑↓ navigate    ↵ launch    esc close";
        text-color = mkLiteral "@dim";
        background-color = mkLiteral "transparent";
        font = "FiraCode Nerd Font 10";
        vertical-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.0";
      };
    };
  };

  home.packages = with pkgs; [
    inputs.zen-browser.packages."${stdenv.hostPlatform.system}".default
    inputs.noctalia.packages."${stdenv.hostPlatform.system}".default
    gcr
    swaybg
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
