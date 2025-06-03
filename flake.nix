{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: {
    nixosConfigurations.t460 = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = inputs;
      modules = [
        inputs.home-manager.nixosModules.home-manager
        ./hosts/t460-jonathan/configuration.nix
      ];
    };
  };
}
