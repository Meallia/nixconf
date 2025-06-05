{
  disko.devices = {
    disk = {
      root = {
        device = "/dev/nvme0n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "500M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "1G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                mountOptions = [
                  "noatime"
                ];
              };
            };
            swap = {
              size = "4G";
              content = {
                type = "swap";
                discardPolicy = "both";
              };
            };
            nix = {
              # A full system should be around 3G
              # We provision something like 3 times this amount to be safe
              size = "10G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/nix";
                mountOptions = [
                  "noatime"
                ];
              };
            };
            home = {
              size = "1G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/home";
                mountOptions = [
                  "noatime"
                  "nodev"
                  "noexec"
                  "nosuid"
                ];
              };
            };
            opt = {
              size = "1G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/opt";
                mountOptions = [
                  "noatime"
                  "nodev"
                  "nosuid"
                ];
              };
            };
            var = {
              size = "1G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/var";
                mountOptions = [
                  "noatime"
                  "nodev"
                  "noexec"
                  "nosuid"
                ];
              };
            };
            var-log = {
              size = "10G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/var/log";
                mountOptions = [
                  "noatime"
                  "nodev"
                  "noexec"
                  "nosuid"
                ];
              };
            };
            var-lib = {
              size = "50G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/var/lib";
                mountOptions = [
                  "noatime"
                  "nodev"
                ];
              };
            };
            var-lib-longhorn = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/var/lib/longhorn";
                mountOptions = [
                  "noatime"
                  "nodev"
                  "noexec"
                  "nosuid"
                ];
              };
            };
          };
        };
      };
    };
  };
}
