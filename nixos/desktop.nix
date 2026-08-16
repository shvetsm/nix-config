# Hyprland desktop: Wayland compositor + login manager.
{...}: let
  wallpaper = ../assets/wallpapers/cyberpunk-black-cat-rooftop.jpg;
in {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    # Launch via UWSM so the compositor's own readiness gates
    # graphical-session.target, instead of racing an exec-once
    # dbus-update-activation-environment against dependent user services
    # (hyprshell, waybar, hyprpaper, ...).
    withUWSM = true;
  };

  # withUWSM only enables the uwsm binary/systemd units; it doesn't wire a
  # compositor entry on its own, so the "Hyprland" session regreet lists
  # stays the plain (non-UWSM) launch unless a uwsm session is declared here.
  # This adds a separate "Hyprland (UWSM)" entry alongside it, so the plain
  # one still works as a fallback if UWSM ever fails to start.
  programs.uwsm.waylandCompositors.hyprland = {
    prettyName = "Hyprland";
    comment = "Hyprland compositor managed by UWSM";
    binPath = "/run/current-system/sw/bin/Hyprland";
  };

  # greetd + regreet, run via cage. Same login-prompter approach as the
  # inspiration config, using nixpkgs' built-in module instead of a hand-rolled
  # wrapper script. Recolored to Synthwave '84 and reskinned to match veila's
  # "diagonal" lock theme: same wallpaper + dim/tint overlay. Widgets are
  # squared-off terminal/arcade panels (monospace, thick neon borders, sharp
  # corners) instead of soft frosted-glass pills.
  services.displayManager.regreet = {
    enable = true;
    settings.GTK.application_prefer_dark_theme = true;
    extraCss = ''
      window {
        background-image:
          linear-gradient(rgba(249, 42, 173, 0.08), rgba(249, 42, 173, 0.08)),
          linear-gradient(rgba(21, 15, 34, 0.4), rgba(21, 15, 34, 0.4)),
          url("file://${wallpaper}");
        background-size: cover;
        background-position: center;
        background-repeat: no-repeat;
      }

      label {
        color: #f2eefc;
        font-family: "JetBrainsMono Nerd Font";
      }

      .background {
        background: transparent;
        border: none;
        box-shadow: none;
      }

      #clock_frame {
        background: transparent;
        border: none;
      }

      #clock_frame label {
        color: #03edf9;
        text-shadow: 0 0 12px rgba(3, 237, 249, 0.6);
      }

      entry {
        background-color: rgba(10, 8, 20, 0.75);
        color: #f9f9f9;
        border: 2px solid #b93cf6;
        border-radius: 4px;
        padding: 8px 18px;
        caret-color: #03edf9;
        font-family: "JetBrainsMono Nerd Font";
        letter-spacing: 1px;
        box-shadow: inset 0 0 12px rgba(185, 60, 246, 0.12);
      }

      entry:focus-within {
        border-color: #f92aad;
        box-shadow:
          0 0 12px rgba(249, 42, 173, 0.55),
          inset 0 0 12px rgba(249, 42, 173, 0.18);
      }

      entry.password text {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 22px;
        font-weight: bold;
        letter-spacing: 6px;
        color: #f92aad;
        text-shadow: 0 0 6px rgba(249, 42, 173, 0.85), 0 0 14px rgba(249, 42, 173, 0.5);
      }

      button {
        background-color: rgba(10, 8, 20, 0.75);
        color: #f2eefc;
        border: 2px solid #b93cf6;
        border-radius: 4px;
        font-family: "JetBrainsMono Nerd Font";
        letter-spacing: 1px;
      }

      button:hover {
        border-color: #03edf9;
        box-shadow: 0 0 10px rgba(3, 237, 249, 0.45);
      }

      button.suggested-action {
        background-color: #f92aad;
        color: #1a1626;
        border-color: #f92aad;
      }

      button.suggested-action:hover {
        background-color: #ff5cd0;
        box-shadow: 0 0 10px rgba(249, 42, 173, 0.6);
      }

      button.destructive-action {
        background-color: transparent;
        color: #fe4450;
        border-color: #fe4450;
      }

      button.destructive-action:hover {
        background-color: rgba(254, 68, 80, 0.15);
        box-shadow: 0 0 10px rgba(254, 68, 80, 0.45);
      }

      comboboxtext, combobox {
        background-color: rgba(10, 8, 20, 0.75);
        color: #f2eefc;
        border: 2px solid #b93cf6;
        border-radius: 4px;
        font-family: "JetBrainsMono Nerd Font";
      }

      #notif_info, #notif_label {
        color: #ff8b39;
        font-family: "JetBrainsMono Nerd Font";
      }
    '';
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Trash, network mounts, and thumbnails for Thunar.
  services.gvfs.enable = true;
}
