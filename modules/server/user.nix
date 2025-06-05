{config, ...}: let
  cfg = config.server;
in {
  config = {
    services.userborn.enable = true;
    users.mutableUsers = false;
    users.users."${cfg.user}" = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = cfg.sshPublicKeys;
      extraGroups = ["wheel"];
    };

    security.sudo = {
      enable = true;
      extraRules = [
        {
          groups = ["wheel"];
          commands = [
            {
              command = "ALL";
              options = ["NOPASSWD"];
            }
          ];
        }
      ];
    };
  };
}
