{
  modulesPath,
  lib,
  pkgs,
  ...
}: {
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      max-jobs = "auto";
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--max-freed 1G --delete-older-than 7d";
    };
  };

  services.openssh = {
    enable = true;
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGtMNPJuxK69ILh7r6ZLwBB5cJJReJOL+R84MPe5Q3Er jonathan@mambo"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDx+vksyDrMjCLjnL2xsB8QIvnzeWE6VCJ7L6Vg/0fqx jonathan@t460"
  ];

  sops.age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];

  time.timeZone = "Europe/Paris";

  environment.systemPackages = with pkgs; [
    vim
    htop
    dnsutils
  ];
}
