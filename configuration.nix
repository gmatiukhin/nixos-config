# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

# let
#   home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz"; in
{
  imports =
    [ # Include the results of the hardware scan.
      # (import "${home-manager}/nixos")
      # <home-manager/nixos>
      ./hardware-configuration.nix
      ./zfs.nix
      ./home.nix
    ];

  nixpkgs.config.allowUnfree = true;


  networking.hostName = "Deimos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

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
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };
   
    displayManager = {
        defaultSession = "none+i3";
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        dmenu #application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock #default i3 screen locker
        i3blocks #if you are planning on using i3blocks over i3status
     ];
    };

    layout = "us,ru";
    xkbOptions = "grp:shifts_toggle";
  };

  ### Laptop
  # Fn+F* keys
  programs.light.enable = true;
  services.actkbd = {
    enable = true;
    bindings = [
      # Fn+F1 => screen brightness down
      { keys = [ 224 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -U 10"; } 
      # Fn+F2 => screen brightness up
      { keys = [ 225 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -A 10"; }
    ];
  };
  # Touchpad
  services.xserver.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
  };

  # Enable sound.
  sound = {
    enable = true;
    mediaKeys.enable = true;
  };
  hardware.pulseaudio.enable = true;

  users.defaultUserShell = pkgs.zsh;
  users.users.gmatiukhin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" ];
  };

  environment = {
    shells = [ pkgs.zsh ];
    # pathsToLink = [ "share/zsh" ];
    variables = {
      EDITOR = "nvim"; VISUAL = "nvim";
      BROWSER = "firefox";
      TERMINAL = "kitty";
    };
    systemPackages = with pkgs; [
      firefox
      neovim
      kitty
      ripgrep xclip
      wget curl
      git gh
      lxappearance

      #build essentials
      gcc gdb python3Full
      nodePackages.npm
      rustup

      # viewers
      qview # image viewer
      evince # document viewer
      vlc
      xfce.thunar
      flameshot

      # misc
      htop unzip mc 
    ];
  };

  programs = {
    git.enable = true;
    zsh = {
      enable = true;
      # keep this `false` in order to have fast load times
      # [Explanation](https://github.com/nix-community/home-manager/issues/108)
      enableCompletion = false;
    };
    steam.enable = true;
    htop.enable = true;
    dconf.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };


  services = {
    openssh.enable = true; # Enable the OpenSSH daemon.
    tlp.enable = true; # cli save battery power
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

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

