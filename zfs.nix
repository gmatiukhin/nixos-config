{ config, pkgs, ... }:

{
  networking.hostId = "cc73853f";
  boot = {
    supportedFilesystems = [ "zfs" ];
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    loader = {
      efi = {
        efiSysMountPoint = "/boot/efis/nvme0n1p1";
        canTouchEfiVariables = true;
      };

      generationsDir.copyKernels = true;

      grub = {
        efiInstallAsRemovable = false;
        enable = true;
        version = 2;
        copyKernels = true;
        efiSupport = true;
        zfsSupport = true;
        # extraPrepareConfig = ''
        #   mkdir -p /boot/efis
        #   for i in  /boot/efis/*; do mount $i ; done
        #
        #   mkdir -p /boot/efi
        #   mount /boot/efi
        # '';
        extraInstallCommands = ''
          ESP_MIRROR=$(mktemp -d)
          cp -r /boot/efis/nvme0n1p1/EFI $ESP_MIRROR
          for i in /boot/efis/*; do
           cp -r $ESP_MIRROR/EFI $i
          done
          rm -rf $ESP_MIRROR
        '';
        devices = [
          "/dev/nvme0n1"
        ];
      };
    };
  };
}
