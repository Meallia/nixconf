{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    nh
    nix-output-monitor
    git
    vim
    htop
  ];
}
