{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11-small";

  inputs.disko.url = "github:nix-community/disko";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";

  inputs.sops-nix.url = "github:Mic92/sops-nix";
  inputs.sops-nix.inputs.nixpkgs.follows = "nixpkgs";

  outputs = inputs @ {
    nixpkgs,
    disko,
    sops-nix,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages."${system}";
  in {
    formatter."${system}" = pkgs.alejandra;
    devShells."${system}".default = pkgs.mkShell {
      nativeBuildInputs = with pkgs; [
        sops
        age
        ssh-to-age
        gnumake
      ];
    };
    nixosConfigurations.dysprosium = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        disko.nixosModules.disko
        sops-nix.nixosModules.sops
        {networking.hostName = "dysprosium";}
        ./hosts/dysprosium
      ];
    };
  };
}
