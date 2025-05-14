{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./disk-config.nix
    ./hardware-config.nix
    ../common.nix
  ];
  system.stateVersion = "24.11";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = ["i915.enable_dc=0"];

  environment.systemPackages = with pkgs; [
    kubectl
    k9s
    cri-tools
  ];

  security.sudo.enable = false;
  networking = {
    dhcpcd.enable = false;
    defaultGateway = "172.20.20.1";
    nameservers = ["172.20.0.1"];
    interfaces.enp2s0.ipv4.addresses = [
      {
        address = "172.20.20.200";
        prefixLength = 24;
      }
    ];
  };

  virtualisation.containerd.enable = true;
}
