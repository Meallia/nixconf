{lib, ...}: {
  config = {
    # DNS / NSS config
    services.nscd.enableNsncd = false;
    services.nscd.enable = false;
    system.nssModules = lib.mkForce [];
    services.resolved.enable = true;

    systemd.network.enable = true;

    networking = {
      resolvconf.enable = false;
      useDHCP = false;
      dhcpcd.enable = false;
    };
    time.timeZone = "Europe/Paris";
  };
}
