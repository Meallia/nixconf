{pkgs, ...}: {
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
    nerd-fonts.iosevka-term
  ];

  fonts.fontconfig = {
    enable = true;
  };

  programs.plasma.fonts.fixedWidth = {
    family = "JetBrainsMono Nerd Font";
    pointSize = 12;
  };

  programs.plasma.fonts.general = {
    family = "Iosevka Nerd Font";
    pointSize = 12;
  };

  programs.plasma.fonts.small = {
    family = "Iosevka Nerd Font";
    pointSize = 9;
  };

  programs.plasma.fonts.toolbar = {
    family = "Iosevka Nerd Font";
    pointSize = 11;
  };

  programs.plasma.fonts.menu = {
    family = "Iosevka Nerd Font";
    pointSize = 11;
  };

  programs.plasma.fonts.windowTitle = {
    family = "Iosevka Nerd Font";
    pointSize = 11;
  };
}
