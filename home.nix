{ config, pkgs, ... }:

{
  imports =
    [ 
      <home-manager/nixos>
    ];

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
        thunderbird tdesktop zoom-us teams spotify
        # graphics
        gimp aseprite ffmpeg shotcut blender obs-studio godot
          
        # misc
        gparted anki wireshark dunst 

        texlive.combined.scheme-full
        btop
      ];
    };

    # Note: probably transfer i3 config here
    # xsession = {
    #   enable = true;
    #   windowManager.i3 = {
    #     enable = true;
    #     config = {
    #       terminal = "kitty";
    #     };
    #   };
    # };

    xdg = {
      enable = true;
      mimeApps = {
        enable = true;
        defaultApplications = {
          "image/png" = [ "qview.desktop" ];
          "image/jpg" = [ "qview.desktop" ];
          "application/pdf" = [ "zathura.desktop" ];
          "application/epub+zip" = [ "zathura.desktop" ];
          "image/vnd.djvu+multipage" = [ "zathura.desktop" ];
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
          # add permissions to your user with `setfacl` for ease of editing
          # this prevents git's dubious directory error
          safe.directory = [
            "/etc/nixos"
            "/etc/nixos/i3/i3blocks/scripts"
          ];
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
            body = "xdg-open $argv & disown";
          };
        };
      };
      home-manager.enable = true;
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
      #   configPath = "/etc/nixos/i3/rofi/config.rasi";
      # };
    };

    home.stateVersion = "22.11";
  };
}
