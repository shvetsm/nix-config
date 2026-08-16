# Hyprland compositor: keybinds, layout, and look. Colors are Synthwave '84
# (dark purple/navy with hot-pink + cyan neon accents), hardcoded for now
# (no theme flake yet).
{pkgs, ...}: {
  home.packages = [pkgs.pamixer];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    # Pin explicitly: the home-manager default is about to flip from
    # "hyprlang" to "lua". This config is written in hyprlang.
    configType = "hyprlang";

    settings = {
      monitor = [",preferred,auto,1"];

      "$mod" = "SUPER";
      "$terminal" = "ghostty";
      "$launcher" = "fuzzel";

      bind =
        [
          "$mod, Return, exec, $terminal"
          "$mod, D, exec, $launcher"
          "$mod, Q, killactive"
          "$mod, M, exit"
          "$mod, V, togglefloating"
          "$mod, F, fullscreen"
          "$mod, N, exec, swaync-client --toggle-panel --skip-wait"

          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"

          "$mod SHIFT, left, movewindow, l"
          "$mod SHIFT, right, movewindow, r"
          "$mod SHIFT, up, movewindow, u"
          "$mod SHIFT, down, movewindow, d"
        ]
        ++ builtins.concatLists (builtins.genList (
            i: let
              ws = toString (
                if i == 9
                then 0
                else i + 1
              );
            in [
              "$mod, ${ws}, workspace, ${ws}"
              "$mod SHIFT, ${ws}, movetoworkspace, ${ws}"
            ]
          )
          10);

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      general = {
        gaps_in = 4;
        gaps_out = 8;
        border_size = 2;
        "col.active_border" = "rgba(f92aadee) rgba(03edf9ee) 45deg";
        "col.inactive_border" = "rgba(4a3a5eaa)";
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
  };
}
