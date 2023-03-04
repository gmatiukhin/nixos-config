{config, pkgs, lib, ...}:

{
  systemd.services = {
    i3lock = {
      description = "Lock the screen with i3lock";
      wantedBy = [ "sleep.target" ];
      before = [ "sleep.target" ];
      # There should be only one Xorg session running
      # so only 0th display
      environment = {
        DISPLAY = ":0";
      };
      serviceConfig = {
        Type = "forking"; # Otherwise systemd would never suspend while i3lock is running
        ExecStart = "${pkgs.i3lock}/bin/i3lock";
        User = "gmatiukhin";
      };
    };
  };

  systemd.services.i3lock.enable = true;
}
