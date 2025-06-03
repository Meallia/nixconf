inputs @ {
  config,
  lib,
  pkgs,
  ...
}: {
  nix = {
    gc = {
      automatic = true;
      dates = "daily";
      persistent = true;
      options = "--delete-older-than 7d";
    };
    settings = {
      auto-optimise-store = true;
      trusted-users = ["root"];
      warn-dirty = false;
      min-free = toString (100 * 1024 * 1024);
      max-free = toString (1024 * 1024 * 1024);
      max-jobs = "auto";
      cores = 0;
    };
  };
}
