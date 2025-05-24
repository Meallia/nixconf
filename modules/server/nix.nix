{config, ...}: let
  cfg = config.server;
in {
  config = {
    nix = {
      gc.automatic = true;
      optimise.automatic = true;
      settings = {
        auto-optimise-store = true;
        experimental-features = ["nix-command" "flakes"];
        trusted-users = ["root" "@wheel"];
      };
    };
  };
}
