{lib, ...}: {
  config = {
    services.lvm.enable = false;

    systemd.suppressedSystemUnits = [
      "rescue.target"
      "rescue.service"
      "debug-shell.service"

      "sound.target"
      "bluetooth.target"
      "printer.target"
      "smartcard.target"

      "systemd-growfs@.service"
      "systemd-growfs-root.service"

      "sys-kernel-debug.mount"
      "sys-kernel-tracing.mount"
      "sys-kernel-config.mount"

      "systemd-backlight@.service"
      "systemd-rfkill.service"
      "systemd-rfkill.socket"

      "hibernate.target"
      "suspend.target"
      "suspend-then-hibernate.target"
      "sleep.target"
      "hybrid-sleep.target"
      "systemd-hibernate.service"
      "systemd-hibernate-clear.service"
      "systemd-hybrid-sleep.service"
      "systemd-suspend.service"
      "systemd-suspend-then-hibernate.service"
    ];

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
    };
  };
}
