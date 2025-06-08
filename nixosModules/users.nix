inputs @ {
  lib,
  config,
  pkgs,
  ...
}: {
  users.users.jonathan = {
    isNormalUser = true;
    description = "Jonathan GAYVALLET";
    extraGroups = ["networkmanager" "wheel" "docker" "kvm"];
  };
}
