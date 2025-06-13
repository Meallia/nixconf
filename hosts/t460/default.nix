{...} @ inputs: {
  imports = [
    ./hardware-configuration.nix
    ./partitions.nix
    ../../nixosModules
  ];
  networking.hostName = "t460";

  services.fwupd.enable = true;

  programs.steam.enable = true;
  programs.steam.remotePlay.openFirewall = true;
  programs.steam.localNetworkGameTransfers.openFirewall = true;
}
