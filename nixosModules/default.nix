inputs @ {
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./autoUpgrade.nix
    ./home-manager.nix
    ./keyboard.nix
    ./locale.nix
    ./networking.nix
    ./nix.nix
    ./packages.nix
    ./printing.nix
    ./sound.nix
    ./ssh.nix
    ./sudo.nix
    ./users.nix
    ./virtualisation.nix
    ./xserver.nix
  ];
}
