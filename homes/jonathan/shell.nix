{...}: {
  programs.starship = {
    enable = true;
    settings = {
      directory = {
        truncation_length = 10;
        truncate_to_repo = false;
      };
    };
  };

  programs.bash = {
    enable = true;
    historyControl = [
      "ignoreboth"
      "erasedups"
    ];
    historyIgnore = [
      "history *"
    ];
  };
}
