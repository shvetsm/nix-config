# Hyprshell: GTK4 window switcher + app launcher, replacing fuzzel.
# - Hold Alt and tap Tab to cycle through open windows (most-recently-used
#   order) across all workspaces; releasing Alt focuses the selected window,
#   which jumps Hyprland to its workspace.
# - SUPER + D opens the overview (window grid + app launcher), replacing the
#   old fuzzel keybind.
{...}: {
  services.hyprshell = {
    enable = true;
    settings.windows = {
      switch = {
        modifier = "alt";
        # Default filter is [current_monitor], which (since a monitor only
        # shows one workspace at a time) hides windows on other workspaces.
        # Empty list = no filtering, so all workspaces are included.
        filter_by = [];
      };

      overview = {
        key = "d";
        modifier = "super";
      };
    };
  };

  # hyprshell talks to Hyprland's IPC socket directly, so it's useless (and
  # noisy in the logs) under niri. Its unit is WantedBy=graphical-session.target,
  # which both sessions reach, so gate it on the desktop the systemd user
  # manager was started under.
  systemd.user.services.hyprshell.Unit.ConditionEnvironment = "XDG_CURRENT_DESKTOP=Hyprland";
}
