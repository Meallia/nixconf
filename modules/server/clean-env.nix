{
  lib,
  config,
  ...
}: let
  mkForce = lib.mkOverride 51; # Slightly lower priority than lib.mkForce
in {
  # Unset hard-coded environment variables from nixos
  environment.profileRelativeSessionVariables.QTWEBKIT_PLUGIN_PATH = lib.mkForce [];
  environment.profileRelativeSessionVariables.GTK_PATH = lib.mkForce [];
  environment.sessionVariables.NO_AT_BRIDGE = lib.mkForce null;
  environment.sessionVariables.GTK_A11Y = lib.mkForce null;
  environment.variables.SSH_ASKPASS = lib.mkForce null;
  environment.extraInit = "unset QTWEBKIT_PLUGIN_PATH GTK_PATH";
}
