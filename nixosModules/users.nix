{...}: {
  users.users.jonathan = {
    isNormalUser = true;
    description = "Jonathan GAYVALLET";
    extraGroups = ["networkmanager" "wheel" "docker" "kvm"];
  };
  home-manager.users.jonathan = ../homes/jonathan;
}
