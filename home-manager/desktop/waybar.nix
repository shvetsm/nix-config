# Waybar: the workspace pager + status bar along the top of the screen.
# Colors are Synthwave '84 (dark purple/navy with hot-pink + cyan neon
# accents), hardcoded for now (no theme flake yet).
{...}: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = [
      {
        layer = "top";
        position = "top";
        height = 34;

        modules-left = ["hyprland/workspaces"];
        modules-center = ["clock"];
        modules-right = ["custom/swaync" "pulseaudio" "network" "battery" "tray"];

        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            default = "";
            active = "";
          };
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

        tray.spacing = 10;

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
      #tray {
        padding: 0 10px;
      }

      #clock {
        color: #03edf9;
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
    '';
  };
}
