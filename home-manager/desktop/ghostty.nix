# Ghostty terminal, launched via SUPER+Return (hyprland.nix) and Mod+T
# (niri's config.kdl, unmanaged by home-manager). GTK's client-side
# titlebar/tab-bar doesn't play well with a tiling WM, so it's turned off.
{...}: {
  programs.ghostty = {
    enable = true;
    settings = {
      window-decoration = "none";
    };
  };
}
