{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rke2-pkgs = {
      url = "gitlab:jonathang/rke2-pkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    disko,
    sops-nix,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    overlays = [
      (final: prev: {rke2-pkgs = inputs.rke2-pkgs.packages.${system};})
    ];
    infra = import ./infra.nix;
  in {
    formatter.${system} = pkgs.alejandra;
    devShells.${system}.default = import ./shell.nix {inherit pkgs;};

    nixosConfigurations =
      nixpkgs.lib.attrsets.mapAttrs
      (name: systemConfig:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            disko.nixosModules.disko
            sops-nix.nixosModules.sops
            ./disk-config.nix
            ./hardware-config.nix
            ./modules/server
            ./modules/rke2
            systemConfig
            {nixpkgs.overlays = overlays;}
            {networking.hostName = name;}
          ];
        })
      infra.hosts;
  };
}
