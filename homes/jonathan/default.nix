{
  config,
  pkgs,
  ...
}: {
  home.username = "jonathan";
  home.homeDirectory = "/home/jonathan";

  home.stateVersion = "25.05";
  home.packages = with pkgs; [
    kdePackages.kate
    kdePackages.kcalc
    discord
    minigalaxy
    libreoffice-qt
    vlc
    yt-dlp
    jetbrains.pycharm-professional
    python3
    python3.pkgs.pydevd
    nixd
  ];

  #TODO: set fonts

  programs.git = {
    enable = true;
    userEmail = "jonathan.mael.gayvallet@gmail.com";
    userName = "Jonathan GAYVALLET";
    aliases = {};
    delta.enable = true;
    ignores = [];
  };

  programs.firefox = {enable = true;};
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
    nix-direnv.enable = true;
  };

  programs.home-manager.enable = true;
}
