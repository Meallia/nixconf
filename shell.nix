{ pkgs ? import <nixpkgs>, ... }:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    nixos-anywhere
    sops
    age
    ssh-to-age
    gnumake
    k9s
    cilium-cli
  ];
}
