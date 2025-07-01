{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../../homeManagerModules/glab
  ];
  programs.glab = {
    enable = true;
    aliases = {
      username = "!glab api /user | ${lib.getExe pkgs.yq-go} '.username'";

      group-clone = "repo clone --group $1 --paginate --include-subgroups --archived=false --preserve-namespace=true";

      open = "open-branch";
      open-branch = "repo view --web";
      open-mr = "mr view --web";
      open-issue = "issue view --web $1";

      my-issues = "!glab issue list --assignee=@me";
    };
    config = {
      git_protocol = "ssh";
      check_update = false;
      telemetry = false;
      hosts = {
        "gitlab.com" = {
          git_protocol = "ssh";
          api_protocol = "https";
        };
      };
    };
  };
}
