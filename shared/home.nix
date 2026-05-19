{ inputs, lib, pkgs, config, ... }:

{
  imports = [ ];

  xdg.configFile."gtk-4.0/gtk.css".force = true;
  xdg.configFile."gtk-4.0/settings.ini".force = true;
  xdg.configFile."fastfetch/config.jsonc".text = ''
    {
      "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",

      "logo": {
        "type":   "kitty-direct",
        "source": "/home/saturn/Pictures/Images/nixosfastfetch.png",
        "width":  26,
        "height": 13,
        "padding": {
          "top":   1,
          "left":  1,
          "right": 3
        }
      },

      "display": {
        "separator": " ",
        "key": {
          "width": 16
        }
      },

      "modules": [
        {
          "type": "title",
          "format": "\u001b[38;2;180;190;254m{user-name}\u001b[0m\u001b[38;2;88;91;112m@\u001b[0m\u001b[38;2;180;190;254m{host-name}\u001b[0m"
        },
        {
          "type": "custom",
          "format": "\u001b[38;2;88;91;112m┌────────────────────────────────────────────────────────────┐\u001b[0m"
        },
        {
          "type": "os",
          "key": "\u001b[38;2;88;91;112m│\u001b[0m \u001b[38;2;180;190;254mOS\u001b[0m             \u001b[38;2;88;91;112m│\u001b[0m",
          "format": "{pretty-name} {version-id}"
        },
        {
          "type": "kernel",
          "key": "\u001b[38;2;88;91;112m│\u001b[0m \u001b[38;2;180;190;254mKernel\u001b[0m         \u001b[38;2;88;91;112m│\u001b[0m",
          "format": "{release}"
        },
        {
          "type": "uptime",
          "key": "\u001b[38;2;88;91;112m│\u001b[0m \u001b[38;2;180;190;254mUptime\u001b[0m         \u001b[38;2;88;91;112m│\u001b[0m",
          "format": "{hours} hours, {minutes} mins"
        },
        {
          "type": "custom",
          "format": "\u001b[38;2;88;91;112m├────────────────────────────────────────────────────────────┤\u001b[0m"
        },
        {
          "type": "wm",
          "key": "\u001b[38;2;88;91;112m│\u001b[0m \u001b[38;2;137;180;250mWM\u001b[0m             \u001b[38;2;88;91;112m│\u001b[0m"
        },
        {
          "type": "shell",
          "key": "\u001b[38;2;88;91;112m│\u001b[0m \u001b[38;2;137;180;250mShell\u001b[0m          \u001b[38;2;88;91;112m│\u001b[0m"
        },
        {
          "type": "terminal",
          "key": "\u001b[38;2;88;91;112m│\u001b[0m \u001b[38;2;137;180;250mTerminal\u001b[0m       \u001b[38;2;88;91;112m│\u001b[0m"
        },
        {
          "type": "datetime",
          "key": "\u001b[38;2;88;91;112m│\u001b[0m \u001b[38;2;137;180;250mTime\u001b[0m           \u001b[38;2;88;91;112m│\u001b[0m",
          "format": "{day-pretty}.{month-pretty}.{year}  {hour-pretty}:{minute-pretty}"
        },
        {
          "type": "custom",
          "format": "\u001b[38;2;88;91;112m├────────────────────────────────────────────────────────────┤\u001b[0m"
        },
        {
          "type": "cpu",
          "key": "\u001b[38;2;88;91;112m│\u001b[0m \u001b[38;2;203;166;247mCPU\u001b[0m            \u001b[38;2;88;91;112m│\u001b[0m",
          "format": "{name} ({cores-logical}c)"
        },
        {
          "type": "gpu",
          "key": "\u001b[38;2;88;91;112m│\u001b[0m \u001b[38;2;203;166;247mGPU\u001b[0m            \u001b[38;2;88;91;112m│\u001b[0m",
          "format": "{name}"
        },
        {
          "type": "memory",
          "key": "\u001b[38;2;88;91;112m│\u001b[0m \u001b[38;2;203;166;247mMemory\u001b[0m         \u001b[38;2;88;91;112m│\u001b[0m"
        },
        {
          "type": "disk",
          "key": "\u001b[38;2;88;91;112m│\u001b[0m \u001b[38;2;203;166;247mDisk\u001b[0m           \u001b[38;2;88;91;112m│\u001b[0m",
          "folders": "/"
        },
        {
          "type": "packages",
          "key": "\u001b[38;2;88;91;112m│\u001b[0m \u001b[38;2;203;166;247mPkgs\u001b[0m           \u001b[38;2;88;91;112m│\u001b[0m",
          "format": "{nix-system} (sys)  {nix-user} (user)"
        },
        {
          "type": "custom",
          "format": "\u001b[38;2;88;91;112m└────────────────────────────────────────────────────────────┘\u001b[0m"
        },
        {
          "type": "colors",
          "paddingLeft": 1,
          "symbol": "circle"
        }
      ]
    }
  '';

  gtk = {
    enable = true;
    theme = {
      name    = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    gtk4.theme = {
      name    = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name    = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name    = "Borealis-cursors";
    package = pkgs.borealis-cursors;
    size    = 24;
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
      font_family      = "FiraCode Nerd Font";
      bold_font        = "FiraCode Nerd Font Bold";
      italic_font      = "FiraCode Nerd Font";
      bold_italic_font = "FiraCode Nerd Font Bold";
      font_size        = "12.0";
      disable_ligatures = "never";
      cursor                     = "#b4befe";
      cursor_text_color          = "#11111b";
      cursor_shape               = "beam";
      cursor_blink_interval      = "0.5";
      cursor_stop_blinking_after = "0";
      scrollback_lines = 10000;
      mouse_hide_wait       = "3.0";
      copy_on_select        = "clipboard";
      strip_trailing_spaces = "smart";
      window_padding_width    = "10 14";
      hide_window_decorations = "yes";
      remember_window_size    = true;
      tab_bar_edge          = "bottom";
      tab_bar_style         = "powerline";
      tab_powerline_style   = "slanted";
      tab_title_template    = "{index}: {title}";
      active_tab_font_style = "bold";
      active_tab_background   = "#b4befe";
      active_tab_foreground   = "#11111b";
      inactive_tab_background = "#1e1e2e";
      inactive_tab_foreground = "#6c7086";
      tab_bar_background      = "#11111b";
      enable_audio_bell    = "no";
      visual_bell_duration = "0.0";
      repaint_delay   = 10;
      input_delay     = 3;
      sync_to_monitor = "yes";
      url_style            = "curly";
      url_color            = "#89b4fa";
      detect_urls          = "yes";
      underline_hyperlinks = "hover";
      background           = "#11111b";
      foreground           = "#cdd6f4";
      selection_background = "#313244";
      selection_foreground = "#cdd6f4";
      color0  = "#45475a";
      color1  = "#f38ba8";
      color2  = "#a6e3a1";
      color3  = "#f9e2af";
      color4  = "#89b4fa";
      color5  = "#cba6f7";
      color6  = "#89dceb";
      color7  = "#bac2de";
      color8  = "#585b70";
      color9  = "#f38ba8";
      color10 = "#a6e3a1";
      color11 = "#f9e2af";
      color12 = "#89b4fa";
      color13 = "#cba6f7";
      color14 = "#89dceb";
      color15 = "#a6adc8";
    };
    keybindings = {
      "ctrl+shift+enter"     = "new_window_with_cwd";
      "ctrl+shift+t"         = "new_tab_with_cwd";
      "ctrl+equal"           = "increase_font_size";
      "ctrl+minus"           = "decrease_font_size";
      "ctrl+shift+backspace" = "restore_font_size";
      "ctrl+shift+u"         = "scroll_to_prompt -1";
      "ctrl+shift+d"         = "scroll_to_prompt 1";
    };
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      codeberg = {
        host           = "codeberg.org";
        hostname       = "codeberg.org";
        user           = "git";
        identityFile   = "~/.ssh/id_ed25519";
      };
      github = {
        host           = "github.com";
        hostname       = "github.com";
        user           = "git";
        identityFile   = "~/.ssh/id_ed25519";
      };
      "*" = {
        forwardAgent        = false;
        addKeysToAgent      = "no";
        compression         = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts      = false;
        userKnownHostsFile  = "~/.ssh/known_hosts";
        controlMaster       = "no";
        controlPath         = "~/.ssh/master-%r@%n:%p";
        controlPersist      = "no";
      };
    };
    enableDefaultConfig = false;
  };

  programs.rofi = {
    enable  = true;
    package = pkgs.rofi;
    extraConfig = {
      modi               = "drun";
      show-icons         = true;
      icon-theme         = "Papirus-Dark";
      display-drun       = ">";
      drun-display-format = "{icon} {name}";
      disable-history    = false;
      sidebar-mode       = false;
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
        width            = mkLiteral "620px";
        background-color = mkLiteral "@bg";
        border           = mkLiteral "2px";
        border-color     = mkLiteral "@accent";
        border-radius    = mkLiteral "12px";
      };
      "mainbox" = {
        padding  = mkLiteral "0px";
        spacing  = mkLiteral "0px";
        children = mkLiteral "[header, inputbar, separator, listview, footer]";
      };
      "header" = {
        background-color = mkLiteral "@hdr";
        padding          = mkLiteral "8px 14px";
        border           = mkLiteral "0 0 1px 0";
        border-color     = mkLiteral "@hdrbdr";
        border-radius    = mkLiteral "10px 10px 0 0";
        expand           = false;
        orientation      = mkLiteral "horizontal";
        children         = mkLiteral "[textbox-left, textbox-right]";
      };
      "textbox-left" = {
        expand           = true;
        str              = "NixOS ${lib.trivial.release} (${lib.trivial.codeName}) ${pkgs.stdenv.hostPlatform.uname.processor}";
        text-color       = mkLiteral "@accent";
        background-color = mkLiteral "transparent";
        font             = "FiraCode Nerd Font 11";
        vertical-align   = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.0";
      };
      "textbox-right" = {
        expand           = false;
        str              = "ROFI";
        text-color       = mkLiteral "@dim";
        background-color = mkLiteral "transparent";
        font             = "FiraCode Nerd Font 11";
        vertical-align   = mkLiteral "0.5";
        horizontal-align = mkLiteral "1.0";
      };
      "inputbar" = {
        background-color = mkLiteral "@button";
        border-radius    = mkLiteral "8px";
        padding          = mkLiteral "8px 12px";
        margin           = mkLiteral "10px 12px 0";
        spacing          = mkLiteral "0px";
        children         = mkLiteral "[prompt, entry]";
        border           = mkLiteral "1px";
        border-color     = mkLiteral "#3a3f4b";
      };
      "prompt" = {
        padding    = mkLiteral "0 10px 0 2px";
        text-color = mkLiteral "@accent";
      };
      "entry" = {
        text-color = mkLiteral "@fg";
      };
      "separator" = {
        background-color = mkLiteral "@button";
        height           = mkLiteral "1px";
        margin           = mkLiteral "6px 12px 4px";
        expand           = false;
      };
      "listview" = {
        lines        = 10;
        columns      = 1;
        fixed-height = false;
        scrollbar    = false;
        spacing      = mkLiteral "2px";
        cycle        = true;
        dynamic      = true;
        layout       = mkLiteral "vertical";
        padding      = mkLiteral "4px 12px 6px";
      };
      "element" = {
        padding       = mkLiteral "7px 10px";
        border-radius = mkLiteral "6px";
        children      = mkLiteral "[element-icon, element-text]";
      };
      "element selected" = {
        background-color = mkLiteral "@accent";
        text-color       = mkLiteral "@button";
      };
      "element-icon" = {
        size   = mkLiteral "24px";
        margin = mkLiteral "0 12px 0 0";
      };
      "element-text" = {
        vertical-align = mkLiteral "0.5";
      };
      "footer" = {
        background-color = mkLiteral "transparent";
        padding          = mkLiteral "7px 14px";
        spacing          = mkLiteral "0px";
        expand           = false;
        border           = mkLiteral "1px 0 0 0";
        border-color     = mkLiteral "@button";
        children         = mkLiteral "[textbox-footer]";
      };
      "textbox-footer" = {
        expand           = true;
        str              = "↑↓ navigate    ↵ launch    esc close";
        text-color       = mkLiteral "@dim";
        background-color = mkLiteral "transparent";
        font             = "FiraCode Nerd Font 10";
        vertical-align   = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.0";
      };
    };
  };

  home.packages = with pkgs;
  [
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
