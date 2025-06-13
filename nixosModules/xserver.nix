{...}: {
  services.xserver.enable = false;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.sddm.autoNumlock = true;
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "jonathan";
  services.desktopManager.plasma6.enable = true;
}
