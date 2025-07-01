{
  lib,
  config,
  pkgs,
  ...
}: let
  cfgKey = "permanentSSH";
  cfg = config.${cfgKey};
in {
  options.${cfgKey} = {
    enable = lib.mkEnableOption "Permanent SSH Sessions";
    pkg = lib.mkPackageOption pkgs "openssh" {};
    sessions = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            host = lib.mkOption {type = lib.types.str;};
            name = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
            };
            tunnels = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [];
            };
          };
        }
      );
      default = {};
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.user.services =
      lib.mapAttrs' (name: session: let
        name' = with builtins; head (filter isString [session.name name]);
      in {
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
            in "${lib.getExe cfg.pkg} -M -oBatchMode=yes -oExitOnForwardFailure=yes -v -nNT  ${session.host} ${tunnels}";
          };
        };
      })
      cfg.sessions;
  };
}
