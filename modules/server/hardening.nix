{lib, ...}: {
  config = {
    services.nscd.enableNsncd = false;
    services.nscd.enable = false;
    system.nssModules = lib.mkForce [];

    systemd = {
      coredump.enable = false;
      enableEmergencyMode = false;
      sleep.extraConfig = ''
        AllowSuspend=no
        AllowHibernation=no
      '';
      watchdog = {
        runtimeTime = "15s";
        rebootTime = "30s";
        kexecTime = "1m";
      };
      services = {
        "rescue".enable = false;
      };
    };
  };
}
