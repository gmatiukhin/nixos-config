# Edit this configuration file to define what should be installed on

# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./zfs.nix

    ./home.nix

    ./services/polkit-gnome-authentication-agent-1.nix
    ./services/i3lock.nix
  ];

  nixpkgs.config.allowUnfree = true;


  boot.kernel.sysctl = {
    "kernel.sysrq" = 1;
  };

  networking.hostName = "Deimos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  fonts.fonts = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "FiraCode"
      ];
    })
  ];

  services = {
    xserver = {
      enable = true;
      autorun = true;

      desktopManager = {
        xterm.enable = false;
        wallpaper.mode = "fill";
      };

      displayManager = {
        autoLogin = {
          enable = true;
          user = "gmatiukhin";
        };

        lightdm = {
          enable = true;
          autoLogin.timeout = 0;
          greeter.enable = false;
        };

        defaultSession = "none+i3";
      };

      windowManager = {
        i3 = {
          enable = true;
          configFile = "/etc/nixos/i3/config";
          extraPackages = with pkgs; [
            i3lock
            i3blocks
            rofi
          ];
        };
      };

      xautolock = {
        enable = true;
        locker = "${pkgs.i3lock}/bin/i3lock";
        nowlocker = "${pkgs.i3lock}/bin/i3lock";
        time = 10;
        extraOptions = [
          "-lockaftersleep"
        ];
      };

      # For touchpad support
      libinput = {
        enable = true;
        touchpad.naturalScrolling = true;
      };

      layout = "us,de,ru";
      xkbOptions = "grp:alt_shift_toggle";
    };

    # Fn+F* keys
    actkbd = {
      enable = true;
      bindings = [
        # Fn+F1 => screen brightness down
        { keys = [ 224 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -U 5"; }
        # Fn+F2 => screen brightness up
        { keys = [ 225 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -A 5"; }
      ];
    };

    # Networking 
    zerotierone = {
      enable = true;
    };
    tailscale.enable = true;
    openssh.enable = true;

    # Misc
    tlp.enable = true; # cli save battery power
    logind = {
      lidSwitch = "suspend";
    };

    sysstat.enable = true;
    rsyslogd.enable = true;

    # Todo: set thresholds
    earlyoom = {
      enable = false;
    };
    greenclip.enable = true;
    # shadowsocks = {
    #   enable = true;
    #   extraConfig = {
    #     server = builtins.readFile ./utils/shadowsocks/ip;
    #     local_address = "127.0.0.1";
    #     local_port = 1080;
    #   };
    #   port = 53374;
    #   passwordFile = ./utils/shadowsocks/pass;
    #   fastOpen = false;
    # };
  };

  virtualisation = {
    libvirtd = {
      enable = true;
      allowedBridges = [
        "virbr0"
      ];
    };
    docker.enable = true;
  };

  # systemd = {
  #   tmpfiles.rules = [
  #     "d /tmp - - - 5d"
  #   ];
  # };

  security = {
    polkit.enable = true;
    wrappers = {
      ubridge = {
        source = "${pkgs.ubridge}/bin/ubridge";
        capabilities = "cap_net_admin,cap_net_raw=ep";
        owner = "root";
        group = "ubridge";
        permissions = "u+rx,g+x";
      };
    };
  };

  ### Laptop
  programs.light.enable = true;
  # Enable sound.
  sound = {
    enable = true;
    mediaKeys.enable = true;
  };
  hardware.pulseaudio.enable = true;

  users.defaultUserShell = pkgs.fish;
  users.users.gmatiukhin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "wireshark" "ubridge" "docker" "networkmanager" ];
  };
  users.groups.ubridge = { };
  users.groups.netdev = { };

  environment = {
    variables = {
      TERMINAL = "kitty";
      # this is used to force broken apps (like telegram-desktop) to use correct themes
      XDG_CURRENT_DESKTOP = "gnome";
    };

    shells = [ pkgs.fish ];
    systemPackages = with pkgs; [
      home-manager

      firefox
      neovim
      kitty

      ripgrep
      xclip
      wget
      curl
      ffmpeg

      #build essentials
      gcc
      gdb
      python3Full
      gnumake
      cmake
      rustup

      # viewers
      qview
      zathura
      vlc
      xfce.thunar
      flameshot

      docker
      docker-compose

      # network
      nmap
      dig
      shadowsocks-rust

      # man pages
      man-pages
      man-pages-posix

      # misc
      htop
      unzip
      mc
      killall
      tree
      polkit_gnome
      dunst

      xkb-switch
      sysstat
      acpi
      iw
      envsubst
      lxappearance

      inetutils
    ];
  };

  programs = {
    fish.enable = true;
    git.enable = true;
    steam.enable = true;
    htop.enable = true;
    dconf.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    openvpn3.enable = true;
    wireshark.enable = true;
  };

  documentation = {
    dev.enable = true;
    man = {
      enable = true;
    };
    doc.enable = true;
    info.enable = true;
    nixos = {
      enable = true;
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Strict reverse path filtering breaks Tailscale exit node use and some subnet routing setups.
  networking.firewall.checkReversePath = "loose";

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}

