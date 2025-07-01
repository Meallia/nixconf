{pkgs, ...}: {
  home.packages = with pkgs; [
    kubectl
    k9s
    fluxcd
    kube-score
    kube-capacity
    kyverno
    cosign
    kubernetes-helm
    kind
    trivy
    kustomize
  ];

  programs.kubecolor = {
    enable = true;
    enableAlias = true;
  };
}
