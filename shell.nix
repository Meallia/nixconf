{pkgs ? import <nixpkgs> {}}: {
  default = pkgs.mkShellNoCC {
    NIX_CONFIG = "experimental-features = nix-command flakes";
    nativeBuildInputs = with pkgs; [
      nixos-rebuild
      home-manager
      nh
      git
    ];
  };
}
