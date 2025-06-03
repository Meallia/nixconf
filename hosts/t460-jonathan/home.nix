{
  config,
  pkgs,
  ...
}: {
  home.username = "jonathan";
  home.homeDirectory = "/home/jonathan";

  home.stateVersion = "25.05";
  home.packages = with pkgs; [
    kdePackages.kcalc
    libreoffice-qt
    vlc
    yt-dlp
    nixd
    jetbrains.pycharm-professional
  ];

  programs.bash = {
    enable = true;
  };

  programs.lsd = {
    enable = true;
  };

  programs.starship = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
  };

  programs.home-manager.enable = true;
}
