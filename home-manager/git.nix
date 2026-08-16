# Git identity, plus delta (diff pager) and lazygit (terminal UI).
{...}: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Mark Shvets";
        email = "shvetsm@gmail.com";
      };
      merge.conflictStyle = "zdiff3";
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
    };
  };

  programs.lazygit = {
    enable = true;
    # lazygit >=0.60 replaced `git.paging` with `git.diffRenderers`; the old
    # key made lazygit try to self-migrate the config and rewrite it on
    # disk, which fails since it's a read-only nix store symlink.
    settings.git.diffRenderers = [
      {
        name = "delta";
        type = "stdinFilter";
        # --paging=never: lazygit does its own scrolling, so delta shouldn't
        # invoke its own pager on top of that.
        command = "delta --dark --paging=never";
        colorArg = "always";
      }
    ];
  };
}
