# Fish shell + starship prompt, plus plugins:
# - fzf (PatrickF1/fzf.fish): fzf key bindings for history/files/etc.
# - done: notification when a long-running command finishes
# - sponge: scrubs failed/typo'd commands out of history
# - autopair: auto-close matching brackets/quotes
# - puffer: text expansions
{pkgs, ...}: {
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "fzf";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
      {
        name = "sponge";
        src = pkgs.fishPlugins.sponge.src;
      }
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair.src;
      }
      {
        name = "puffer";
        src = pkgs.fishPlugins.puffer.src;
      }
    ];
  };

  home.packages = [pkgs.fzf];

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };
}
