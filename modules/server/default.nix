{
  config,
  lib,
  modulesPath,
  ...
}: let
  cfg = config.server;
in {
  imports = [
    (modulesPath + "/profiles/minimal.nix")
    # Requires system.etc.overlay.enable = true and we might not be ready for it
    # (modulesPath + "/profiles/perlless.nix")
    ./build-vm.nix
    ./clean-env.nix
    ./hardening.nix
    ./networking.nix
    ./nix.nix
    ./packages.nix
    ./user.nix
  ];
  options.server = {
    user = lib.mkOption {
      type = lib.types.str;
    };
    sshPublicKeys = lib.mkOption {
      type = lib.types.listOf lib.types.singleLineStr;
    };
  };
  config = {
    system.stateVersion = config.system.nixos.release;
    sops.age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    services.openssh = {
      enable = true;
      hostKeys = [
        {
          path = "/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
    };
    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    services.fstrim.enable = true;
  };
}
