{ config, pkgs, ... }:

let
  unstableTarball = fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
in
{
  imports = [ <home-manager/nixos> ];

  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  home-manager.users.gmatiukhin = {
    home = {
      username = "gmatiukhin";
      homeDirectory = "/home/gmatiukhin";
      sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        BROWSER = "firefox";
        TERMINAL = "kitty";
        PATH = "$PATH:$HOME";
      };

      packages = with pkgs; [
        thunderbird tdesktop zoom-us teams spotify discord
        # graphics
        gimp aseprite shotcut blender obs-studio godot
          
        # misc
        gparted anki wireshark obsidian

        texlive.combined.scheme-full
        btop
        ghidra

        gns3-gui gns3-server
        dynamips ubridge vpcs
      ];
    };

    # Note: probably have lockers defined here
    # services = {
    #   screen-locker = {
    #     enable = true;
    #     lockCmd = "${pkgs.i3lock}/bin/i3lock";
    #     inactiveInterval = 1;
    #     xautolock = {
    #       enable = true;
    #       detectSleep = true;
    #       extraOptions = [
    #         "-lockaftersleep"
    #       ];
    #     };
    #   };
    # };

    xsession = {
      enable = true;
      initExtra = ''
        i3lock -n
        greenclip daemon &
      '';
      # Note: probably transfer i3 config here
      # windowManager.i3 = {
      #   enable = true;
      #   config = {
      #     terminal = "kitty";
      #   };
      # };
    };

    # Look here for most common types
    # https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types
    xdg = {
      enable = true;
      mimeApps = {
        enable = true;
        defaultApplications = {
          "image/png" = [ "qView.desktop" ];
          "image/jpeg" = [ "qView.desktop" ];
          "image/gif" = [ "qView.desktop" ];
          "image/svg+xml" = [ "qView.desktop" ];
          "application/pdf" = [ "org.pwmt.zathura.desktop" ];
          "application/epub+zip" = [ "org.pwmt.zathura.desktop" ];
          "image/vnd.djvu+multipage" = [ "org.pwmt.zathura.desktop" ];
        };
      };
    };

    gtk = {
      enable = true;
      font = {
        name = "FiraCode Nerd Font Regular";
        size = 10;
      };
      cursorTheme = {
        name = "breeze_cursors";
      };
      iconTheme = {
        package = pkgs.libsForQt5.breeze-icons;
        name = "breeze-dark";
      };
      theme = {
        package = pkgs.libsForQt5.breeze-gtk;
        name = "Breeze-Dark";
      };
    };

    qt = {
      enable = true;
      platformTheme = "gnome";
      style = {
        package = pkgs.libsForQt5.breeze-qt5;
        name = "Breeze";
      };
    };

    programs = {
      home-manager.enable = true;
      git = {
        enable = true;
        userName = "Grigorii Matiukhin";
        userEmail = "grigory36m@gmail.com";
        signing = {
          signByDefault = true;
          # change if using this config on different pc
          key = "1E37AF9F8D4BB40C";
        };
        extraConfig = {
          init.defaultBranch = "main";
        };
      };
      gh = {
        enable = true;
        enableGitCredentialHelper = true;
      };
      fish = {
        enable = true;
        shellAbbrs = {
          update = "sudo nixos-rebuild switch";
          tryit = "nix-shell --run fish -p";
        };
        functions = {
          open = {
            body = "xdg-open $argv &; disown";
          };
        };
      };
      neovim = {
        enable = true;
        extraPackages = with pkgs; [
          # Required packages for nvim to function
          nodejs

          # Formatters and such for null-ls
          black
          stylua

          # LSP
          nodePackages.pyright
          rust-analyzer
          sumneko-lua-language-server
          clang clang-tools
          texlab
        ];
      };
      # Note: consider using this for rofi
      # rofi = {
      #   enable = true;
      #   configPath = "home/gmatiukhin/.config/nixos/i3/rofi/config.rasi";
      # };
    };

    home.stateVersion = "22.11";
  };
}
