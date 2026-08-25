# niri config, versioned instead of living only at ~/.config/niri/config.kdl.
# It's plain KDL (not Nix-generated), but home-manager symlinks it into the
# read-only Nix store, so edits have to go in niri/config.kdl here, then
# `home-manager switch` -- editing the live ~/.config/niri/config.kdl path
# directly no longer works once it's a store symlink.
{pkgs, ...}: {
  xdg.configFile."niri/config.kdl".source = ./niri/config.kdl;

  # Unlike Hyprland, niri doesn't bundle its own Xwayland, so X11-only apps
  # (e.g. Enpass, which ships no Wayland Qt platform plugin and falls back to
  # xcb) can't find a display and fail to start. xwayland-satellite provides
  # a standalone rootless Xwayland; pin it to :0 so DISPLAY is predictable.
  home.packages = [pkgs.xwayland-satellite];
  home.sessionVariables.DISPLAY = ":0";

  systemd.user.services.xwayland-satellite = {
    Unit = {
      Description = "Xwayland outside your Wayland compositor";
      PartOf = "graphical-session.target";
      After = "graphical-session.target";
      # Hyprland already has its own bundled Xwayland; only run this under niri.
      ConditionEnvironment = "XDG_CURRENT_DESKTOP=niri";
    };
    Service = {
      ExecStart = "${pkgs.xwayland-satellite}/bin/xwayland-satellite :0";
      Restart = "on-failure";
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
