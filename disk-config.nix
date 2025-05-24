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
                  "defaults"
                  "noatime"
                  "discard"
                ];
              };
            };
            nix = {
              size = "5G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/nix";
                mountOptions = [
                  "defaults"
                  "noatime"
                  "discard"
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
                  "defaults"
                  "noatime"
                  "discard"
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
                  "defaults"
                  "noatime"
                  "discard"
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
                  "defaults"
                  "noatime"
                  "discard"
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
                  "defaults"
                  "noatime"
                  "discard"
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
                  "defaults"
                  "noatime"
                  "discard"
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
                  "defaults"
                  "noatime"
                  "discard"
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
