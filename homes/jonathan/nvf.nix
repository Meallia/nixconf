{ ... }:
{
  programs.nvf = {
    enable = true;
    defaultEditor = true;
    enableManpages = true;
    settings = {
      vim = {
        viAlias = false;
        vimAlias = true;
        lineNumberMode = "number";
        spellcheck.enable = true;

        options = {
          shiftwidth = 2;
          tabstop = 2;
          softtabstop = 2;
        };

        theme = {
          enable = true;
          name = "gruvbox";
          style = "dark";
        };

        lsp = {
          enable = true;
          formatOnSave = true;
        };

        statusline.lualine.enable = true;
        autocomplete.nvim-cmp.enable = true;
        telescope.enable = true;
        binds.cheatsheet.enable = true;

        languages = {
          enableTreesitter = true;
          enableFormat = true;

          rust.enable = true;
          python.enable = false;
          nix.enable = true;
          go.enable = true;
          markdown.enable = true;
          lua.enable = true;
        };
      };
    };
  };
}
