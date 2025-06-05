inputs@{ lib, config, pkgs, ... }:
let
  configKey = "rebootRequired";
  cfg = config.${configKey};
in
{
  options.${configKey} = {
    enable = lib.mkEnableOption "Automatically create /var/run/reboot-required if nixos-rebuild switch requires it";
  };
  config = lib.mkIf cfg.enable { };
}
