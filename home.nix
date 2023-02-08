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

    xdg = {
      enable = true;
      desktopEntries = {
        qview = {
            name = "qview";
            exec = "qview %f";
            mimeType = [ "image/png" "image/jpg" ];
          };
        evince = { 
          name = "evince";
          exec = "evince %f";
          mimeType = [ "application/pdf" ];
        };
      };

      mimeApps = {
        enable = true;
        defaultApplications = {
          "image/png" = [ "qview.desktop" ];
          "application/pdf" = [ "evince.desktop" ];
        };
      };
    };

    gtk = {
      enable = true;
      # font.name = "";
      cursorTheme = {
        package = pkgs.quintom-cursor-theme;
        name = "Quintom_Ink";
      };
      iconTheme = {
        package = pkgs.tela-circle-icon-theme;
        name = "Tela-circle-dark";
      };
      theme = {
        package = pkgs.orchis-theme;
        name = "Orchis-Purple-Dark-Compact";
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
          safe.directory = "/etc/nixos";
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
          clang
          texlab
        ];
      };
    };

    home.stateVersion = "22.11";
  };
}
