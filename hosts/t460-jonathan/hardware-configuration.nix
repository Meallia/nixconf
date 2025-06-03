{...}: {
  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "sd_mod" "rtsx_pci_sdmmc"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/996c7d24-81c1-4a17-afc9-16d45f1ed9cf";
    fsType = "ext4";
    options = ["noatime"];
  };

  boot.initrd.luks.devices."luks-3ae3d6d4-6cf6-471c-932c-79cacc741ea9".device = "/dev/disk/by-uuid/3ae3d6d4-6cf6-471c-932c-79cacc741ea9";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/30C9-A302";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/4573d5c0-d180-404c-9f30-c4b69808f985";}
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;
}
