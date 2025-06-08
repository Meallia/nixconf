{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    system = "x86_64-linux";
    pkgs = inputs.nixpkgs.legacyPackages.${system};
  in {
    formatter.${system} = pkgs.alejandra;
    devShells.${system}.default = import ./shell.nix {inherit pkgs;};
    nixosConfigurations.t460 = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = inputs;
      modules = [
        inputs.home-manager.nixosModules.home-manager
        ./hosts/t460
      ];
    };
    nixosConfigurations.mambo = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = inputs;
      modules = [
        inputs.home-manager.nixosModules.home-manager
        ./hosts/mambo
      ];
    };
  };
}
