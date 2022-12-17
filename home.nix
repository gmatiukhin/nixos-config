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
      file = {
        ".p10k.zsh".source = ./zsh/powerlevel10k.conf;
      };

      packages = with pkgs; [
        thunderbird tdesktop zoom-us teams spotify
        # graphics
        gimp aseprite ffmpeg shotcut blender obs-studio godot
          
        # misc
        gparted anki wireshark dunst 

        texlive.combined.scheme-full
        texlab
        btop
      ];

      sessionVariables = {
        PATH = "$PATH:.cargo/bin/";
      };
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
      zsh = import ./zsh/zsh.nix;
      home-manager.enable = true;
    };

    home.stateVersion = "22.11";
  };
}
