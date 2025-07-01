{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    jetbrains.pycharm-professional

        uv
        poetry
    (python3.withPackages (ps:
      with ps; [
        pydevd
        black
        tox
      ]))
  ];
}
