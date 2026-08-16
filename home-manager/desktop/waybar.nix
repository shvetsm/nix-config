# Waybar: the workspace pager + status bar along the top of the screen.
# Colors are Synthwave '84 (dark purple/navy with hot-pink + cyan neon
# accents), hardcoded for now (no theme flake yet).
{pkgs, ...}: let
  # Current conditions for Akron, OH via wttr.in's JSON endpoint. Emits
  # waybar's {text, tooltip} JSON shape.
  weatherScript = pkgs.writeShellScriptBin "waybar-weather" ''
    set -euo pipefail

    data=$(${pkgs.curl}/bin/curl -sf -m 10 'https://wttr.in/Akron,OH?format=j1') || exit 0

    temp=$(${pkgs.jq}/bin/jq -r '.current_condition[0].temp_F' <<<"$data")
    feels=$(${pkgs.jq}/bin/jq -r '.current_condition[0].FeelsLikeF' <<<"$data")
    desc=$(${pkgs.jq}/bin/jq -r '.current_condition[0].weatherDesc[0].value' <<<"$data")
    code=$(${pkgs.jq}/bin/jq -r '.current_condition[0].weatherCode' <<<"$data")

    case "$code" in
      113) icon="☀️" ;;
      116) icon="⛅" ;;
      119|122) icon="☁️" ;;
      143|248|260) icon="🌫️" ;;
      176|263|266|293|296|299|302|305|308|311|314|317|320|350|353|356|359|362|365|368|371|392|395) icon="🌧️" ;;
      179|182|185|227|230|281|284|323|326|329|332|335|338|374|377) icon="🌨️" ;;
      200|386|389) icon="⛈️" ;;
      *) icon="🌡️" ;;
    esac

    ${pkgs.jq}/bin/jq -n \
      --arg text "$icon  ''${temp}°F" \
      --arg tooltip "$desc, feels like ''${feels}°F (Akron, OH)" \
      '{text: $text, tooltip: $tooltip}'
  '';
in {
  home.packages = [weatherScript pkgs.curl pkgs.jq];

  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = [
      {
        layer = "top";
        position = "top";
        height = 34;

        modules-left = ["hyprland/workspaces" "wlr/taskbar"];
        modules-center = ["clock"];
        modules-right = ["custom/swaync" "custom/weather" "pulseaudio" "network" "battery" "tray" "custom/power"];

        "hyprland/workspaces" = {
          format = "{name}";
          # SUPER+1..9,0 in hyprland.nix bind workspaces 1-9 and 0 (the "0"
          # key maps to workspace id 0, not 10), so list all ten here to
          # keep them visible even when empty.
          persistent-workspaces."*" = [1 2 3 4 5 6 7 8 9 0];
        };

        clock = {
          format = "{:%a %d %b  %H:%M}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
        };

        pulseaudio = {
          format = "{icon}  {volume}%";
          format-muted = "  muted";
          format-icons.default = ["" "" ""];
          on-click = "pamixer -t";
        };

        network = {
          format-wifi = "  {essid}";
          format-ethernet = "  connected";
          format-disconnected = "  offline";
        };

        battery = {
          format = "{icon}  {capacity}%";
          format-icons = ["" "" "" "" ""];
          states = {
            warning = 20;
            critical = 10;
          };
        };

        "custom/weather" = {
          exec = "${weatherScript}/bin/waybar-weather";
          return-type = "json";
          interval = 900;
          tooltip = true;
        };

        tray.spacing = 10;

        "wlr/taskbar" = {
          format = "{icon}";
          icon-size = 18;
          tooltip-format = "{title}";
          on-click = "activate";
          on-click-middle = "close";
        };

        "custom/power" = {
          format = "⏻";
          tooltip = false;
          on-click = "wlogout";
        };

        "custom/swaync" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "<span foreground='#f92aad'></span>";
            none = "";
            dnd-notification = "<span foreground='#f92aad'></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='#f92aad'></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='#f92aad'></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };
      }
    ];

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: rgba(38, 35, 53, 0.85);
        color: #f9f9f9;
      }

      #workspaces button {
        padding: 0 8px;
        color: #f9f9f9;
      }

      #workspaces button.active {
        color: #f92aad;
      }

      #workspaces button:hover {
        color: #03edf9;
      }

      #clock,
      #pulseaudio,
      #network,
      #battery,
      #custom-swaync,
      #custom-weather,
      #tray {
        padding: 0 10px;
      }

      #clock {
        color: #03edf9;
      }

      #custom-weather {
        color: #ff8b39;
      }

      #pulseaudio {
        color: #f4eb67;
      }

      #network {
        color: #ff8b39;
      }

      #battery {
        color: #b93cf6;
      }

      #battery.warning {
        color: #f4eb67;
      }

      #battery.critical {
        color: #f92aad;
      }

      #custom-swaync {
        color: #f92aad;
      }

      #taskbar {
        padding: 0 6px;
      }

      #taskbar item {
        padding: 0 6px;
        color: #f9f9f9;
      }

      #taskbar item.active {
        color: #f92aad;
      }

      #custom-power {
        padding: 0 10px;
        color: #f92aad;
        font-size: 16px;
      }

      #custom-power:hover {
        color: #ff8b39;
      }
    '';
  };
}
