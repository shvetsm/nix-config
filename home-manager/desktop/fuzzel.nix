# Fuzzel app launcher, themed to match the Synthwave '84 desktop palette.
{...}: {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=12";
        terminal = "ghostty";
      };
      border = {
        width = 2;
        radius = 6;
      };
      colors = {
        background = "262335ee";
        text = "f9f9f9ff";
        match = "f92aadff";
        selection = "3b2f4dff";
        selection-text = "f9f9f9ff";
        selection-match = "03edf9ff";
        border = "b93cf6ff";
      };
    };
  };
}
