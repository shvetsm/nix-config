# Hyprland desktop: Wayland compositor + login manager.
{...}: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    # Launch via UWSM so the compositor's own readiness gates
    # graphical-session.target, instead of racing an exec-once
    # dbus-update-activation-environment against dependent user services
    # (hyprshell, noctalia, hyprpaper, ...).
    withUWSM = true;
  };

  # Second session to try alongside Hyprland: adds a selectable "niri"
  # entry at the greeter (services.displayManager.sessionPackages) without
  # touching the Hyprland setup above.
  programs.niri.enable = true;

  # hci0 is present (rfkill list) but was never turned on at the OS level;
  # needed for Noctalia's bluetooth widget and the bzmenu tool in
  # home-manager/desktop/fuzzel.nix.
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # withUWSM only enables the uwsm binary/systemd units; it doesn't wire a
  # compositor entry on its own, so the "Hyprland" session in the greeter's
  # session picker stays the plain (non-UWSM) launch unless a uwsm session
  # is declared here. This adds a separate "Hyprland (UWSM)" entry
  # alongside it, so the plain one still works as a fallback if UWSM ever
  # fails to start.
  programs.uwsm.waylandCompositors.hyprland = {
    prettyName = "Hyprland";
    comment = "Hyprland compositor managed by UWSM";
    binPath = "/run/current-system/sw/bin/Hyprland";
  };

  # Login screen: SDDM running qylock's "pixel-night-city" theme (replaces
  # greetd + noctalia-greeter). quickshell.enable is off since the in-session
  # lock screen is now Noctalia's own (home-manager/desktop/noctalia.nix),
  # not qylock's Quickshell lockscreen (`qylock-lock`) — this only installs
  # the SDDM greeter theme.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  programs.qylock = {
    enable = true;
    theme = "pixel-night-city";
    quickshell.enable = false;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Trash, network mounts, and thumbnails for Thunar.
  services.gvfs.enable = true;

  # AC/battery status for Noctalia's power widget: the kernel already
  # reports it fine (/sys/class/power_supply/{AC,BAT0}), but nothing was
  # publishing it over D-Bus, so the widget had no UPower service to query.
  services.upower.enable = true;
}
