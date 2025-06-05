let
  defaults = {
    sshPublicKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGtMNPJuxK69ILh7r6ZLwBB5cJJReJOL+R84MPe5Q3Er jonathan@mambo"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDx+vksyDrMjCLjnL2xsB8QIvnzeWE6VCJ7L6Vg/0fqx jonathan@t460"
    ];
    user = "jonathan";
  };
  networks = {
    common = {
      nameservers = ["172.20.0.1"];
      timeServers = ["172.20.0.1"];
    };
    metal = {
      vlan = 1;
      address = "172.20.1.0";
      prefixLength = 24;
      defaultGateway = "172.20.1.1";
    };
    lan = {
      vlan = 20;
      address = "172.20.20.0";
      prefixLength = 24;
      defaultGateway = "172.20.20.1";
    };
  };
  rke2Clusters = {
    main = {
      server = "172.20.20.23";
      ha = false;
      version = "1.33";
      sopsFile = ./secrets/rke2/main.yaml;
    };
  };
  mkRke2Node = {
    cluster,
    role,
    lanInterface ? "enp2s0",
    lanIp,
    hardware,
    firstServer ? false,
  }: {
    imports = [(./hardware + "/${hardware}.nix")];
    networking = {
      inherit (networks.common) nameservers timeServers;
    };
    systemd.network.networks."30-${lanInterface}" = {
      matchConfig.Name = "${lanInterface}";
      address = ["${lanIp}/${toString networks.lan.prefixLength}"];
      routes = [{Gateway = networks.lan.defaultGateway;}];
      linkConfig.RequiredForOnline = "routable";
    };
    server = {
      inherit (defaults) sshPublicKeys user;
    };
    rke2 =
      cluster
      // {
        inherit role firstServer;
        interface = lanInterface;
        enable = true;
      };
  };
in {
  hosts = {
    technetium = mkRke2Node {
      cluster = rke2Clusters.main;
      role = "agent";
      lanIp = "172.20.20.21";
      hardware = "hp-prodesk-mini";
    };
    promethium = mkRke2Node {
      cluster = rke2Clusters.main;
      role = "agent";
      lanIp = "172.20.20.22";
      hardware = "hp-prodesk-mini";
    };
    dysprosium = mkRke2Node {
      cluster = rke2Clusters.main;
      role = "server";
      lanIp = "172.20.20.23";
      hardware = "hp-prodesk-mini";
    };
  };
}
