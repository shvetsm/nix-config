# Hyprland desktop: Wayland compositor + login manager.
{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.umbriel.nixosModules.default];

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

  # Third session, built by the Noctalia devs specifically to pair with it
  # (home-manager/desktop/umbriel.nix). Adds a "Umbriel" entry at the
  # greeter (its own sessionPackages wiring lives in the flake's
  # nixosModules.default) and is pre-selected as the SDDM default; Hyprland
  # and niri remain as selectable fallbacks.
  programs.umbriel.enable = true;
  services.displayManager.defaultSession = "umbriel";

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

  # Login screen: noctalia-greeter, a greetd-based greeter built by the
  # Noctalia devs to match the in-session Noctalia shell look. Replaces the
  # SDDM + qylock greeter (github:Darkkal44/qylock) tried previously — its
  # "umbriel" session failed to hand off to the compositor on first login
  # (start-umbriel exited instantly with no journal trace, most likely a
  # startup race rather than anything qylock-specific), so backing out to
  # this while that's unresolved.
  services.displayManager.noctalia-greeter = {
    enable = true;
    package = inputs.noctalia-greeter.packages.${pkgs.stdenv.hostPlatform.system}.default;
    settings.session.default = "umbriel";
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Trash, network mounts, and thumbnails for Thunar.
  services.gvfs.enable = true;

  # AC/battery status for Noctalia's power widget: the kernel already
  # reports it fine (/sys/class/power_supply/{AC,BAT0}), but nothing was
  # publishing it over D-Bus, so the widget had no UPower service to query.
  services.upower.enable = true;
}
