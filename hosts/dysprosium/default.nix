{ lib
, pkgs
, ...
}: {
  imports = [
    ./disk-config.nix
    ./hardware-config.nix
    ../common.nix
  ];
  #  environment.etc."rancher/rke2/manifests/install-flux.yaml".source = ./manifests/flux-install.yaml ;

  systemd.tmpfiles.rules = [
    "d  /var/lib/rancher 0755 root root - -"
    "f+ /var/lib/rancher/rke2/server/manifests/flux-install.yaml 0755 root root - ${builtins.replaceStrings ["\n"] ["\\n"] (builtins.readFile ./manifests/flux-install.yaml)}"
  ];

  #  fileSystems.rke2-manifests = {
  #    mountPoint = "/var/lib/rancher/rke2/server/manifests";
  #    device = "overlay";
  #    fsType = "overlay";
  #    options = [
  #      "lowerdir=/etc/rancher/rke2/manifests"
  #      "upperdir=/var/lib/rancher/rke2/server/manifests"
  #      "workdir=/var/lib/rancher/rke2/server/.manifests.work"
  #    ];
  #  };

  environment.variables = {
    KUBECONFIG = "/etc/rancher/rke2/rke2.yaml";
  };
}
