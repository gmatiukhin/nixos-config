{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> {
    config = { allowUnfree = true; };
  };
in
{
  imports = [ <home-manager/nixos> ];


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
        thunderbird
        tdesktop
        zoom-us
        teams
        spotify
        discord
        # graphics
        gimp
        aseprite
        shotcut
        blender
        obs-studio
        # godot
        unstable.godot_4

        # misc
        gparted
        anki
        wireshark
        obsidian
        unstable.freshfetch

        texlive.combined.scheme-full
        btop
        ghidra

        gns3-gui
        gns3-server
        dynamips
        ubridge
        vpcs
        qbittorrent
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
          # fish_prompt = {
          #   body = ''
          #     # This shows up as USER@HOST /home/user/ >, with the directory colored
          #     # $USER and $hostname are set by fish, so you can just use them
          #     # instead of using `whoami` and `hostname`
          #     printf "%s@%s %s%s%s > " $USER $hostname (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
          #   '';
          # };
          fish_greeting = {
            body = ''
              freshfetch
            '';
          };
          dev-shell = {
            body = ''
              cp ~/.config/nixos/utils/dev-template.nix $(pwd)/$argv.nix
              sed -i "s/%name%/$argv/g" $argv.nix
              nvim $argv.nix
            '';
          };
        };
      };
      neovim = {
        enable = true;
        extraPackages = with unstable; [
          # Required packages for nvim to function
          nodejs

          # Formatters and such for null-ls
          black
          stylua
          nodePackages.prettier

          # LSP
          # Note: don't forget to update servers list in nvim config
          sumneko-lua-language-server
          rust-analyzer
          clang
          clang-tools
          nodePackages.pyright
          texlab
          rnix-lsp
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
