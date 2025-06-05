{
  config,
  lib,
  pkgs,
  ...
}: {
  hardware.enableRedistributableFirmware = false;
  hardware.wirelessRegulatoryDatabase = false;
  hardware.cpu.intel.updateMicrocode = true;

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme"];
  boot.blacklistedKernelModules = [];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];
  boot.kernelParams = [
    "i915.enable_dc=0" # prevents freezes when idle on 8500T intel CPUs
  ];

  #  powerManagement.scsiLinkPolicy = "med_power_with_dipm";
  #  boot.kernel.sysctl = {
  #    "kernel.nmi_watchdog" = 0;
  #  };
  #  services.udev.extraRules = ''
  #    SUBSYSTEM=="pci", ATTR{power/control}="auto"
  #    SUBSYSTEM=="ata_port", KERNEL=="ata*", ATTR{device/power/control}="auto"
  #  '';

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
