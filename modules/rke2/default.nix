{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.rke2;
in
{
  options.rke2 = {
    enable = lib.mkEnableOption "RKE2 kubernetes service";
    server = lib.mkOption {
      type = lib.types.str;
      description = "The IP address or hostname for the RKE2 API server";
      example = "172.20.20.200";
    };
    interface = lib.mkOption {
      type = lib.types.str;
      description = "The control plane interface";
      example = "eth0";
    };
    version = lib.mkOption {
      type = lib.types.str;
      description = "The version of the rke2 server, either 1.xx or 1.xx.yy";
      example = "1.33";
    };
    sopsFile = lib.mkOption {
      type = lib.types.path;
      description = "Sops file containing the shared secret used to join a server or agent to a cluster.";
    };
    role = lib.mkOption {
      type = lib.types.enum [ "server" "agent" ];
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
  config =
    let
      pkg = pkgs.rke2-pkgs."rke2_${lib.strings.replaceStrings ["."] ["_"] cfg.version}";
      imagesPkg = pkgs.rke2-pkgs."rke2_${lib.strings.replaceStrings ["."] ["_"] cfg.version}_images";
      isServer = cfg.role == "server";
      isFirstServer = isServer && (! cfg.ha or cfg.firstServer);
      isAgent = !isServer;
      manifests =
        {
          flux-install = ./manifests/flux-install.yaml;
          flux-age-key =
          rke2-cilium-config = pkgs.replaceVars ./manifests/rke2-cilium-config.yaml { inherit (cfg) server; };
        }
        // (
          if cfg.ha && isFirstServer
          then {
            kube-vip = pkgs.replaceVars ./manifests/kube-vip.yaml { inherit (cfg) server interface; };
          }
          else { }
        );
    in
    lib.mkIf cfg.enable {
      environment.systemPackages =
        [ pkg ] ++ lib.optionals isServer (with pkgs; [ kubectl k9s ]);

      systemd.tmpfiles.rules =
        [ "L+ /var/lib/rancher/rke2/agent/images/rke2-images.linux-amd64.tar.zst - - - - ${imagesPkg}" ]
        ++ lib.optionals isFirstServer (lib.mapAttrsToList (name: path: "f+ /var/lib/rancher/rke2/server/manifests/${name}.yaml 0640 root root - ${builtins.replaceStrings ["\n"] ["\\n"] (builtins.readFile path)}") manifests);

      #TODO: add PSS and audit policy files

      sops.secrets.rke2-token = {
        format = "yaml";
        sopsFile = cfg.sopsFile;
        mode = "0440";
        key = "token";
      };

      users = lib.mkIf isServer {
        users.etcd = {
          name = "etcd";
          group = "etcd";
          isSystemUser = true;
        };
        groups.etcd = { };
      };

      # We don't want the default implementation
      services.rke2.enable = false;

      systemd.services."rke2-${cfg.role}" =
        let
          configFile =
            (pkgs.formats.yaml { }).generate "rke2-config.yaml"
              (
                { token-file = config.sops.secrets.rke2-token.path; }
                // lib.optionalAttrs (isAgent || ! isFirstServer) { server = "https://${cfg.server}:9345"; }
                // lib.optionalAttrs isServer {
                  etcd-disable-snapshots = true;
                  etcd-expose-metrics = true;
                  tls-san = [ "127.0.0.1" "${cfg.server}" ];
                  disable-kube-proxy = true;
                  disable = [ "rke2-ingress-nginx" "rke2-snapshot-controller" "rke2-snapshot-controller-crd" "rke2-snapshot-validation-webhook" ];
                  cni = [ "multus" "cilium" ];
                  profile = "cis";
                }
              );
        in
        {
          description = "Rancher Kubernetes Engine v2 (${cfg.role})";
          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];
          wantedBy = [ "multi-user.target" ];
          path = with pkgs; [
            # Important utilities used by the kubelet.
            # See: https://github.com/kubernetes/kubernetes/issues/26093#issuecomment-237202494
            # Notice the list in that issue is stale, but as a redundancy reservation.
            #procps # pidof pkill
            #coreutils # uname touch env nice du
            #util-linux # lsblk fsck mkfs nsenter mount umount
            ethtool # ethtool
            socat # socat
            iptables # iptables iptables-restore iptables-save
            #bridge-utils # brctl
            iproute2 # ip tc
            #kmod # modprobe
            lvm2 # dmsetup
            busybox
            #bindfs # mount.bind
          ];
          serviceConfig = {
            Type = "notify";
            Environment = [ "HOME=/root" ];
            KillMode = "process";
            Delegate = "yes";
            LimitNOFILE = 1048576;
            LimitNPROC = "infinity";
            LimitCORE = "infinity";
            TasksMax = "infinity";
            TimeoutStartSec = 0;
            Restart = "always";
            RestartSec = "5s";
            ExecStart = "${pkg}/bin/rke2 ${cfg.role} --config=${configFile}";
            ExecStopPost =
              let
                inherit (pkgs) busybox;
                killProcess = pkgs.writeScript "kill-process.sh" ''
                  #! ${busybox}/bin/bash
                  /run/current-system/systemd/bin/systemd-cgls /system.slice/$1 | \
                  ${busybox}/bin/grep -Eo '[0-9]+ (containerd|kubelet)' | \
                  ${busybox}/bin/awk '{print $1}' | \
                  ${busybox}/bin/xargs -r ${busybox}/bin/kill
                '';
              in
              "-${killProcess} %n";
          };
        };

      environment.variables.KUBECONFIG = "/etc/rancher/rke2/rke2.yaml";

      #warning msg="Failed to load kernel module nft-expr-counter with modprobe"
      #info msg="Set sysctl 'net/netfilter/nf_conntrack_tcp_timeout_close_wait' to 3600"
      #info msg="Set sysctl 'net/netfilter/nf_conntrack_max' to 196608"
      #info msg="Set sysctl 'net/netfilter/nf_conntrack_tcp_timeout_established' to 86400"

      systemd.oomd.enable = false; # let kubelet handle this
      boot.kernelModules = [ "overlay" "br_netfilter" ];
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
        firewall.enable = false;
        firewall.trustedInterfaces = [
          "cilium_host"
          "cilium_net"
          "cilium_vxlan"
          "lxc+"
        ];
      };
    };
}
