# Hyprland desktop: Wayland compositor + login manager.
{...}: let
  wallpaper = ../assets/wallpapers/cyberpunk-black-cat-rooftop.jpg;
in {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # greetd + regreet, run via cage. Same login-prompter approach as the
  # inspiration config, using nixpkgs' built-in module instead of a hand-rolled
  # wrapper script. Recolored to Synthwave '84 and reskinned to match veila's
  # "diagonal" lock theme: same wallpaper, dark scrim, and borderless pill
  # widgets floating directly on the image instead of a boxed card.
  services.displayManager.regreet = {
    enable = true;
    settings.GTK.application_prefer_dark_theme = true;
    extraCss = ''
      window {
        background-image:
          linear-gradient(180deg, rgba(18, 15, 30, 0.55) 0%, rgba(18, 15, 30, 0.82) 100%),
          url("file://${wallpaper}");
        background-size: cover;
        background-position: center;
        background-repeat: no-repeat;
      }

      label {
        color: #f2eefc;
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
        background-color: rgba(20, 17, 32, 0.55);
        color: #f9f9f9;
        border: 1px solid #b93cf6;
        border-radius: 999px;
        padding: 6px 16px;
        caret-color: #03edf9;
      }

      entry:focus-within {
        border-color: #f92aad;
        box-shadow: 0 0 0 1px #f92aad;
      }

      button {
        background-color: rgba(20, 17, 32, 0.55);
        color: #f2eefc;
        border: 1px solid #b93cf6;
        border-radius: 999px;
      }

      button:hover {
        border-color: #03edf9;
      }

      button.suggested-action {
        background-color: #f92aad;
        color: #1a1626;
        border-color: #f92aad;
      }

      button.suggested-action:hover {
        background-color: #ff5cd0;
      }

      button.destructive-action {
        background-color: transparent;
        color: #fe4450;
        border-color: #fe4450;
      }

      button.destructive-action:hover {
        background-color: rgba(254, 68, 80, 0.15);
      }

      comboboxtext, combobox {
        background-color: rgba(20, 17, 32, 0.55);
        color: #f2eefc;
        border-radius: 999px;
      }

      #notif_info, #notif_label {
        color: #ff8b39;
      }
    '';
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
