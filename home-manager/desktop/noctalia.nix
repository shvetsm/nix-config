# Noctalia: Quickshell-adjacent (native C++/Quickshell-alternative) desktop
# shell (bar, launcher, notifications, control center, session menu, lock
# screen), replacing waybar + swaync + fuzzel-as-launcher + wlogout + qylock's
# Quickshell locker. Shared between the Hyprland and niri sessions
# (nixos/desktop.nix), same as the tools it replaces were. Bar defaults
# already include a compositor-aware workspaces widget (niri's dynamic
# workspaces vs. Hyprland's fixed set autodetected per compositors/niri/
# niri_workspace_backend.h) plus tray/clock/network/bluetooth/volume/battery/
# session, so nothing is overridden here beyond theme + idle-lock.
{
  inputs,
  pkgs,
  ...
}: let
  wallpaper = ../../assets/wallpapers/cyberpunk-black-cat-rooftop.jpg;
in {
  imports = [inputs.noctalia.homeModules.default];

  programs.noctalia = {
    enable = true;
    package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
    systemd.enable = true;

    settings = {
      shell = {
        font_family = "JetBrainsMono Nerd Font";
      };

      theme = {
        mode = "dark";
        source = "wallpaper";
        wallpaper_scheme = "m3-content";
      };

      # Resolve coordinates from IP geolocation rather than a fixed
      # address, so this stays correct as-is across machines/locations.
      location = {
        auto_locate = true;
      };

      weather = {
        unit = "imperial";
      };

      wallpaper = {
        enabled = true;
        default.path = "${wallpaper}";
      };

      # Native auto-lock (replaces the old swayidle -> qylock-lock service):
      # lock the session after 5 minutes idle, same timeout qylock.nix used
      # to run via swayidle.
      idle = {
        behavior = {
          lock = {
            timeout = 300;
            action = "lock";
            enabled = true;
          };
        };
      };
    };
  };
}
