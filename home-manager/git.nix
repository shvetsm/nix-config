# Git identity, plus difftastic (structural diffs) and lazygit (terminal UI).
{...}: {
  programs.git = {
    enable = true;
    settings.user = {
      name = "Mark Shvets";
      email = "shvetsm@gmail.com";
    };
  };

  programs.difftastic = {
    enable = true;
    git = {
      enable = true;
      mode = "both";
    };
  };

  programs.lazygit.enable = true;
}
