{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.plasma-manager.homeManagerModules.plasma-manager
  ];
  programs.plasma.enable = true;
  programs.plasma.input.keyboard.numlockOnStartup = "on";
}
