# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{...}: {
  imports = [
    ./hardware-configuration.nix
    ./partitions.nix
    ../../nixosModules
  ];
  networking.hostName = "mambo";

  programs.steam.enable = true;
  programs.steam.remotePlay.openFirewall = true;
  programs.steam.localNetworkGameTransfers.openFirewall = true;

  services.tor = {
    enable = true;
    client.enable = true;
    settings = {
      ExcludeExitNodes = "{fr}";
    };
  };
}
