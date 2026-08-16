# Fish shell. Kept in its own file since we'll be adding plugins here.
{...}: {
  programs.fish = {
    enable = true;
    plugins = [
      # Add plugins here, e.g.:
      # { name = "z"; src = pkgs.fishPlugins.z.src; }
    ];
  };
}
