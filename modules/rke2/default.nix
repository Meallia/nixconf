{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.rke2;
in {
  options.rke2 = {
    enable = lib.mkEnableOption "RKE2 kubernetes service";
    server = lib.mkOption {
      type = lib.types.str;
      description = "The IP address or hostname for the RKE2 API server";
      example = "172.20.20.200";
    };
    version = lib.mkOption {
      type = lib.types.str;
      description = "The version of the rke2 server, either 1.xx or 1.xx.yy";
      example = "1.33";
    };
    token = lib.mkOption {
      type = lib.types.str;
      description = "Shared secret used to join a server or agent to a cluster.";
    };
    role = lib.mkOption {
      type = lib.types.enum ["server" "agent"];
      description = "The role of the RKE2 node (server or agent)";
      example = "agent";
      default = "agent";
    };
    ha = lib.mkOption {
      type = lib.types.bool;
      description = "Is the control plane running in Hight-Availability mode";
      example = false;
      default = false;
    };
    firstServer = lib.mkOption {
      type = lib.types.bool;
      description = "Is this server the first one to come online";
      example = false;
      default = false;
    };
  };
  config = lib.mkIf cfg.enable {
    #    environment.systemPackages = [
    #      pkgs."rke2_${lib.strings.replaceStrings ["."] ["_"] cfg.version}"
    #    ];
    #    services.rke2 = {
    #      enable = true;
    #    };
    environment.etc."rancher/rke2/config.yaml".text =
      builtins.toJSON
      (
        {
          token = "${cfg.token}";
        }
        // lib.optionalAttrs ((cfg.role == "agent") || (cfg.ha && ! cfg.firstServer)) {server = "https://${cfg.server}:9345";}
        // lib.optionalAttrs (cfg.role == "server") {
          etcd-disable-snapshots = true;
          etcd-expose-metrics = true;
          tls-san = ["127.0.0.1" "${cfg.server}"];
          disable = ["rke2-ingress-nginx" "rke2-snapshot-controller" "rke2-snapshot-controller-crd" "rke2-snapshot-validation-webhook"];
        }
      );

    boot.kernelModules = ["overlay" "br_netfilter"];
    boot.kernel.sysctl = {
      "net.bridge.bridge-nf-call-iptables" = 1;
      "net.bridge.bridge-nf-call-ip6tables" = 1;
      "net.ipv4.ip_forward" = 1;
      "vm.panic_on_oom" = 0;
      "vm.overcommit_memory" = 1;
      "kernel.panic" = 10;
      "kernel.panic_on_oops" = 1;
    };
    networking = {
      firewall.checkReversePath = "loose";
      firewall.trustedInterfaces = [
        "cilium_host"
        "cilium_net"
        "cilium_vxlan"
        "lxc+"
      ];
    };
  };
}
