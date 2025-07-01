{
  inputs,
  pkgs,
  ...
}: {
  home.username = "jonathan";
  home.homeDirectory = "/home/jonathan";

  imports = [
    inputs.nvf.homeManagerModules.default
    ./fonts.nix
    ./glab.nix
    ./keyboard.nix
    ./kubernetes.nix
    ./nix.nix
    ./nvf.nix
    ./plasma.nix
    ./python.nix
    ./shell.nix
  ];

  home.stateVersion = "25.05";
  home.packages = with pkgs; [
    kdePackages.kate
    kdePackages.kcalc
    discord
    minigalaxy
    libreoffice-qt
    vlc
    yt-dlp
    nixd
    alejandra
    mc
    pre-commit
    ripgrep
    bat
    slack
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

  programs.firefox = {
    enable = true;
  };

  programs.lf = {
    enable = true;
  };

  programs.command-not-found = {
    enable = true;
  };

  programs.nh = {
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
