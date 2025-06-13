{...}: {
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/a2bc6c08-518a-46fc-b533-42530e8e15f6";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/B1AC-DA67";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/a088b540-2ee1-43cd-807a-660bd900a880";}
  ];
}
