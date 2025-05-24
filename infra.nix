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
      nameservers = [ "172.20.0.1" ];
      timeServers = [ "172.20.0.1" ];
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
      server = "172.20.20.20";
      token = "abcdefghijkl";
      ha = false;
      version = "1.33";
    };
  };
  mkIPv4Address = network: address: {
    addresses = [
      {
        inherit address;
        prefixLength = network.prefixLength;
      }
    ];
  };
  mkRke2Node =
    { cluster
    , role
    , lanIp
    ,
    }: {
      networking = {
        inherit (networks.lan) defaultGateway;
        inherit (networks.common) nameservers timeServers;
        interfaces = {
          enp2s0.ipv4 = mkIPv4Address networks.lan lanIp;
        };
      };
      server = {
        inherit (defaults) sshPublicKeys user;
      };
      rke2 =
        cluster
        // {
          inherit role;
          enable = true;
        };
    };
in
{
  hosts = {
    technetium = mkRke2Node {
      cluster = rke2Clusters.main;
      role = "server";
      lanIp = "172.20.20.21";
    };
    promethium = mkRke2Node {
      cluster = rke2Clusters.main;
      role = "agent";
      lanIp = "172.20.20.22";
    };
    dysprosium = mkRke2Node {
      cluster = rke2Clusters.main;
      role = "agent";
      lanIp = "172.20.20.23";
    };
  };
}
