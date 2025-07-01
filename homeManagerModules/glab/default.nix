{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.glab;
in {
  options.programs.glab = {
    enable = lib.mkEnableOption "glab";
    pkg = lib.mkPackageOption pkgs "glab" {};
    patchPkgFilePermissions = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Apply patch for https://gitlab.com/gitlab-org/cli/-/issues/1041";
    };
    aliases = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Aliases for glab commands";
    };
    config = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Config for glab";
    };
  };
  config = let
    pkg =
      if ! cfg.patchPkgFilePermissions
      then cfg.pkg
      else cfg.pkg.overrideAttrs (previousAttrs: {
        patches = (previousAttrs.patches or []) ++ [
          ./ignore-config-permissions.patch
        ];
      });
  in
    lib.mkIf cfg.enable
    {
      home.packages = [pkg];
      xdg.configFile."glab-cli/aliases.yml" = {
        text = lib.generators.toYAML {} cfg.aliases;
      };
#      xdg.configFile."glab-cli/config.yml" = {
#        text = lib.generators.toYAML {} cfg.config;
#      };
    };
}
