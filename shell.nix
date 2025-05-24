{pkgs ? import <nixpkgs>, ...}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    sops
    age
    ssh-to-age
    gnumake
  ];
}
