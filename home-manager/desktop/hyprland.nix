# Hyprland compositor: keybinds, layout, and look. Colors are Synthwave '84
# (dark purple/navy with hot-pink + cyan neon accents), hardcoded for now
# (no theme flake yet).
{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.generators) mkLuaInline;

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
  home.packages = [pkgs.pamixer];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    # Hyprland 0.57 drops the legacy .conf/hyprlang format entirely; this
    # config is written for the Lua config API.
    configType = "lua";

    settings = {
      monitor = {
        output = "";
        mode = "preferred";
        position = "auto";
        scale = "auto";
      };

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

      bind =
        [
          (mkBind (modKey "Return") "hl.dsp.exec_cmd(\"ghostty\")" null)
          (mkBind (modKey "D") "hl.dsp.exec_cmd(\"fuzzel\")" null)
          (mkBind (modKey "Q") "hl.dsp.window.close()" null)
          (mkBind (modKey "M") "hl.dsp.exit()" null)
          (mkBind (modKey "V") "hl.dsp.window.float({ action = \"toggle\" })" null)
          (mkBind (modKey "F") "hl.dsp.window.fullscreen()" null)
          (mkBind (modKey "N") "hl.dsp.exec_cmd(\"swaync-client --toggle-panel --skip-wait\")" null)

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
        ];
    };
  };
}
