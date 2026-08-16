# Hyprland compositor: keybinds, layout, and look. Colors are Synthwave '84
# (dark purple/navy with hot-pink + cyan neon accents), hardcoded for now
# (no theme flake yet).
{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.generators) mkLuaInline;

  wallpaper = ../../assets/wallpapers/cyberpunk-black-cat-rooftop.jpg;

  # `hl.bind(keys, dispatcher, opts?)` — one bind per list entry.
  mkBind = keys: dispatcher: opts:
    {
      _args =
        [keys (mkLuaInline dispatcher)]
        ++ lib.optional (opts != null) opts;
    };

  mod = "SUPER";
  modKey = key: "${mod} + ${key}";
  modShiftKey = key: "${mod} + SHIFT + ${key}";
in {
  home.packages = [
    pkgs.pamixer
    pkgs.playerctl
    pkgs.xfce.thunar
    pkgs.xfce.thunar-archive-plugin
    pkgs.xfce.thunar-volman
  ];

  # Same wallpaper as the greeter (nixos/desktop.nix) and veila's lock
  # screen, so it stays consistent from login through to the desktop.
  #
  # hyprpaper 0.8 rewrote its config parser (hyprlang-based) and dropped the
  # old flat `preload = path` / `wallpaper = eDP-1,path` syntax entirely —
  # `preload` isn't a registered key anymore, and a flat `wallpaper =` line
  # silently matches no monitor ("Monitor eDP-1 has no target" in the logs).
  # Wallpapers are now `wallpaper { monitor = ...; path = ...; }` blocks.
  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      wallpaper = [
        {
          monitor = "eDP-1";
          path = "${wallpaper}";
        }
        {
          monitor = "DP-6";
          path = "${wallpaper}";
        }
      ];
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    # UWSM (nixos/desktop.nix: programs.hyprland.withUWSM) now owns session
    # startup and activates graphical-session.target itself once Hyprland is
    # actually ready, so this exec-once dbus-update-activation-environment +
    # hyprland-session.target dance is redundant and would race it.
    systemd.enable = false;
    # Hyprland 0.57 drops the legacy .conf/hyprlang format entirely; this
    # config is written for the Lua config API.
    configType = "lua";

    settings = {
      # Laptop panel (eDP-1) stays at the origin; the external Dell U2725QE
      # (DP-6) sits to its left. Position is in post-scale logical pixels, so
      # at 3840x2160 scaled 1.25x the external monitor is 3072 logical px
      # wide, hence x = -3072 to butt its right edge against the laptop's
      # left edge. Both are top-aligned (y = 0).
      monitor = [
        {
          output = "eDP-1";
          mode = "preferred";
          position = "0x0";
          scale = "1";
        }
        {
          output = "DP-6";
          mode = "preferred";
          position = "-3072x0";
          scale = "1.25";
        }
      ];

      config = {
        general = {
          gaps_in = 4;
          gaps_out = 8;
          border_size = 2;
          col = {
            active_border = {
              colors = ["rgba(f92aadee)" "rgba(03edf9ee)"];
              angle = 45;
            };
            inactive_border = "rgba(4a3a5eaa)";
          };
          layout = "dwindle";
        };

        decoration = {
          rounding = 6;
          shadow.enabled = true;
          blur = {
            enabled = true;
            size = 4;
            passes = 2;
          };
        };

        animations.enabled = true;

        input = {
          kb_layout = "us";
          follow_mouse = 1;
          touchpad.natural_scroll = true;
        };

        misc.disable_hyprland_logo = true;
      };

      # Moonfin (Jellyfin client, ~/Applications/Moonfin.AppImage) has no way
      # to request a Wayland idle-inhibit itself, so veila's idle-lock timer
      # (veila.nix) would otherwise fire mid-playback. Only inhibit while
      # fullscreen so it still locks if the app is left open in a window.
      window_rule = {
        match.class = "^(org.moonfin.linux)$";
        idle_inhibit = "fullscreen";
      };

      bind =
        [
          (mkBind (modKey "Return") "hl.dsp.exec_cmd(\"ghostty\")" null)
          # SUPER + D opens hyprshell's overview (see hyprshell.nix) instead
          # of a manual exec bind.
          (mkBind (modKey "Q") "hl.dsp.window.close()" null)
          (mkBind (modKey "M") "hl.dsp.exit()" null)
          (mkBind (modKey "V") "hl.dsp.window.float({ action = \"toggle\" })" null)
          (mkBind (modKey "F") "hl.dsp.window.fullscreen()" null)
          (mkBind (modKey "N") "hl.dsp.exec_cmd(\"swaync-client --toggle-panel --skip-wait\")" null)
          (mkBind (modKey "E") "hl.dsp.exec_cmd(\"thunar\")" null)

          (mkBind (modKey "left") "hl.dsp.focus({ direction = \"l\" })" null)
          (mkBind (modKey "right") "hl.dsp.focus({ direction = \"r\" })" null)
          (mkBind (modKey "up") "hl.dsp.focus({ direction = \"u\" })" null)
          (mkBind (modKey "down") "hl.dsp.focus({ direction = \"d\" })" null)

          (mkBind (modShiftKey "left") "hl.dsp.window.move({ direction = \"l\" })" null)
          (mkBind (modShiftKey "right") "hl.dsp.window.move({ direction = \"r\" })" null)
          (mkBind (modShiftKey "up") "hl.dsp.window.move({ direction = \"u\" })" null)
          (mkBind (modShiftKey "down") "hl.dsp.window.move({ direction = \"d\" })" null)
        ]
        ++ builtins.concatLists (builtins.genList (
            i: let
              ws = toString (
                if i == 9
                then 0
                else i + 1
              );
            in [
              (mkBind (modKey ws) "hl.dsp.focus({ workspace = ${ws} })" null)
              (mkBind (modShiftKey ws) "hl.dsp.window.move({ workspace = ${ws} })" null)
            ]
          )
          10)
        ++ [
          (mkBind (modKey "mouse:272") "hl.dsp.window.drag()" {mouse = true;})
          (mkBind (modKey "mouse:273") "hl.dsp.window.resize()" {mouse = true;})

          # Media keys: locked = true so they still work while veila has the
          # screen locked. swayosd-client (swayosd.nix) both performs the
          # action and shows the on-screen level indicator; volume/brightness
          # also repeat while held.
          (mkBind "XF86AudioRaiseVolume" "hl.dsp.exec_cmd(\"swayosd-client --output-volume raise\")" {
            locked = true;
            repeating = true;
          })
          (mkBind "XF86AudioLowerVolume" "hl.dsp.exec_cmd(\"swayosd-client --output-volume lower\")" {
            locked = true;
            repeating = true;
          })
          (mkBind "XF86AudioMute" "hl.dsp.exec_cmd(\"swayosd-client --output-volume mute-toggle\")" {locked = true;})
          (mkBind "XF86AudioMicMute" "hl.dsp.exec_cmd(\"swayosd-client --input-volume mute-toggle\")" {locked = true;})
          (mkBind "XF86MonBrightnessUp" "hl.dsp.exec_cmd(\"swayosd-client --brightness raise\")" {
            locked = true;
            repeating = true;
          })
          (mkBind "XF86MonBrightnessDown" "hl.dsp.exec_cmd(\"swayosd-client --brightness lower\")" {
            locked = true;
            repeating = true;
          })
          (mkBind "XF86AudioPlay" "hl.dsp.exec_cmd(\"swayosd-client --playerctl play-pause\")" {locked = true;})
          (mkBind "XF86AudioPause" "hl.dsp.exec_cmd(\"swayosd-client --playerctl play-pause\")" {locked = true;})
          (mkBind "XF86AudioNext" "hl.dsp.exec_cmd(\"swayosd-client --playerctl next\")" {locked = true;})
          (mkBind "XF86AudioPrev" "hl.dsp.exec_cmd(\"swayosd-client --playerctl prev\")" {locked = true;})
        ];
    };
  };
}
