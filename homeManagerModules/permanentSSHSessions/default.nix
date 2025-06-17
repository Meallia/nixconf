{
  lib,
  config,
  pkgs,
  ...
}: let
  cfgKey = "permanentSSHSessions";
  cfg = config.${cfgKey};
in {
  options.${cfgKey} = {
    enable = lib.mkEnableOption "Permanent SSH Sessions";
    pkg = lib.mkPackageOption pkgs "openssh" {};
    sessions = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            host = lib.mkOption {type = lib.types.string;};
            name = lib.mkOption { type = lib.types.string; default = null;};
            tunnels = lib.mkOption {
              type = lib.types.listOf lib.types.string;
              default = [];
            };
          };
        }
      );
      default = {};
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services =
      lib.mapAttrs' (name: session:
      let
        name' = builtins.head ( builtins.filter builtins.isString [session.name name]);
      in
      {
        name = "ssh-${name'}";
        value = {
          Unit.Description = "SSH Session ${name'}";
          Install.WantedBy = ["default.target"];
          Service = {
            Restart = "Always";
            RestartSec = "15";
            KillMode = "mixed";
            ExecStart = let
              tunnels = builtins.concatStringsSep " " session.tunnels;
            in "${cfg.pkg}/bin/ssh -M -oBatchMode=yes -oExitOnForwardFailure=yes  -v -nNT  ${session.host} ${tunnels}";
          };
        };
      })
      cfg.sessions;
  };
}
