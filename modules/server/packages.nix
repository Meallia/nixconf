{ pkgs, ... }: {
  config = {
    environment.systemPackages = with pkgs; [
      ripgrep
      vim
      htop
      dnsutils
      lsof
      lynis
    ];
  };
}
