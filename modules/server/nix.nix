{
  config,
  inputs,
  ...
}: let
  cfg = config.server;
in {
  config = {
    boot.loader.systemd-boot.configurationLimit = 5;

    # invert those two lines to not upload flake source (~400Mb)
    #nixpkgs.flake.setFlakeRegistry = false;
    nix.registry.nixpkgs.flake = inputs.nixpkgs;

    nix = {
      gc = {
        automatic = true;
        options = "-d";
      };
      optimise.automatic = true;
      settings = {
        experimental-features = ["nix-command" "flakes"];
        trusted-users = ["root" "@wheel"];
      };
    };
  };
}
