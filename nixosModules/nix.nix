inputs @ {
  config,
  lib,
  pkgs,
  ...
}: {
  system.stateVersion = config.system.nixos.release;
  nixpkgs.config.allowUnfree = true;
  nix = {
    gc = {
      automatic = true;
      dates = "daily";
      persistent = true;
      options = "--delete-older-than 7d";
    };
    optimise = {
      automatic = true;
      dates = "daily";
      persistent = true;
    };
    settings = {
      experimental-features = ["nix-command" "flakes"];

      trusted-users = ["@wheel"];
      warn-dirty = false;
      min-free = toString (100 * 1024 * 1024);
      max-free = toString (1024 * 1024 * 1024);
      max-jobs = "auto";
      cores = 0;
    };
  };
}
