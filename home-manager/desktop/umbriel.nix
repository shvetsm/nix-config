# Umbriel: independent Wayland compositor built by the Noctalia devs
# specifically to pair with it (nixos/desktop.nix: programs.umbriel.enable,
# and it's the SDDM default session). Settings merge key-by-key on top of
# Umbriel's compiled-in defaults -- only the [[keybinds]] table is a full
# replacement (per docs.noctalia.dev/umbriel/keybinds/), so everything below
# is either a deliberate deviation from default or the complete keybind set.
{inputs, ...}: {
  imports = [inputs.umbriel.homeModules.default];

  programs.umbriel = {
    enable = true;

    settings = {
      general = {
        # Xwayland-only apps (e.g. Enpass) need this; the umbriel package
        # wraps its PATH with xwayland-satellite already (upstream nix/package.nix),
        # so no extra home.packages entry is required here.
        xwayland = true;
      };

      layout = {
        # Umbriel's "scrolling" mode is the same column-based layout niri
        # used (home-manager/desktop/niri.nix); gap matches niri's `gaps 16`.
        mode = "scrolling";
        gap = 16;
      };

      input.touchpad = {
        tap = true;
        natural_scroll = true;
      };

      appearance = {
        # Roughly matches niri's `geometry-corner-radius 20` window rule.
        corner_radius = 20;
      };

      window_rule = [
        # Firefox picture-in-picture floats at a fixed corner, same as the
        # niri window-rule.
        {
          match.title = "^(Picture-in-Picture|Picture in picture)$";
          default_floating = true;
          default_position = {
            x = 20;
            y = 20;
            anchor = "bottom_right";
          };
        }
      ];

      keybinds = {
        # Applications and session
        "Mod+Return" = "spawn:ghostty";
        "Mod+T" = "spawn:ghostty";
        "Mod+D" = "spawn:fuzzel";
        "Mod" = "spawn:noctalia msg panel-toggle launcher";
        "Mod+Space" = "spawn:noctalia msg panel-toggle launcher";
        "Mod+S" = "spawn:noctalia msg panel-toggle control-center";
        "Alt+Tab" = "spawn:noctalia msg window-switcher";
        "Super+Alt+L" = "spawn:noctalia msg session lock";
        "Mod+Q" = "window-close";
        "Mod+Escape" = "session-quit";

        # Fuzzel-backed menus (home-manager/desktop/fuzzel.nix)
        "Ctrl+Alt+E" = "spawn:bemoji";
        "Ctrl+Alt+P" = "spawn:fuzzel-clipboard";
        "Ctrl+Alt+R" = "spawn:fuzzel-history";
        "Ctrl+Alt+W" = "spawn:iwmenu --launcher fuzzel";
        "Ctrl+Alt+B" = "spawn:bzmenu --launcher fuzzel";
        "Ctrl+Alt+A" = "spawn:pwmenu --launcher fuzzel";
        "Ctrl+Alt+C" = "spawn:hyprpicker -a -f hex -n -b";

        # Media and brightness keys, working even while locked
        "XF86AudioRaiseVolume" = {action = "spawn:noctalia msg volume-up"; allow_when_locked = true;};
        "XF86AudioLowerVolume" = {action = "spawn:noctalia msg volume-down"; allow_when_locked = true;};
        "XF86AudioMute" = {action = "spawn:noctalia msg volume-mute"; allow_when_locked = true;};
        "XF86AudioMicMute" = {action = "spawn:noctalia msg mic-mute"; allow_when_locked = true;};
        "XF86AudioPlay" = {action = "spawn:playerctl play-pause"; allow_when_locked = true;};
        "XF86AudioStop" = {action = "spawn:playerctl stop"; allow_when_locked = true;};
        "XF86AudioPrev" = {action = "spawn:playerctl previous"; allow_when_locked = true;};
        "XF86AudioNext" = {action = "spawn:playerctl next"; allow_when_locked = true;};
        "XF86MonBrightnessUp" = {action = "spawn:noctalia msg brightness-up"; allow_when_locked = true;};
        "XF86MonBrightnessDown" = {action = "spawn:noctalia msg brightness-down"; allow_when_locked = true;};

        # Focus navigation
        "Mod+Left" = "window-focus-left";
        "Mod+Down" = "window-focus-down";
        "Mod+Up" = "window-focus-up";
        "Mod+Right" = "window-focus-right";
        "Mod+H" = "window-focus-left";
        "Mod+J" = "window-focus-down";
        "Mod+K" = "window-focus-up";
        "Mod+L" = "window-focus-right";
        "Mod+F1" = "window-focus-next";
        "Mod+WheelUp" = "window-focus-left";
        "Mod+WheelDown" = "window-focus-right";

        # Move columns/windows
        "Mod+Shift+Left" = "column-move-left";
        "Mod+Shift+Down" = "window-move-down";
        "Mod+Shift+Up" = "window-move-up";
        "Mod+Shift+Right" = "column-move-right";

        # Window state and layout
        "Mod+V" = "window-toggle-floating";
        "Mod+Shift+V" = "window-focus-switch-floating";
        "Mod+P" = "window-toggle-pinned";
        "Mod+M" = "window-toggle-maximize-to-edges";
        "Mod+F" = "window-toggle-fullscreen";
        "Mod+Ctrl+F" = "window-toggle-maximize";
        "Mod+R" = "window-cycle-width";
        "Mod+Shift+R" = "window-cycle-width-back";
        "Mod+Comma" = "window-consume-left";
        "Mod+Period" = "window-consume-right";

        # Overview: zoomed-out view of workspaces and windows
        "Mod+O" = {action = "overview-toggle"; repeat = false;};

        # Wraps between outputs -- the two-monitor equivalent of niri's
        # Mod+Shift+arrows monitor-focus binds.
        "Mod+Tab" = "output-focus-next";

        # Workspaces
        "Mod+Page_Up" = "workspace-previous";
        "Mod+Page_Down" = "workspace-next";
        "Mod+U" = "workspace-previous";
        "Mod+I" = "workspace-next";
        "Mod+1" = "workspace-switch:1";
        "Mod+2" = "workspace-switch:2";
        "Mod+3" = "workspace-switch:3";
        "Mod+4" = "workspace-switch:4";
        "Mod+5" = "workspace-switch:5";
        "Mod+6" = "workspace-switch:6";
        "Mod+7" = "workspace-switch:7";
        "Mod+8" = "workspace-switch:8";
        "Mod+9" = "workspace-switch:9";
        "Mod+Shift+1" = "window-move-to-workspace:1";
        "Mod+Shift+2" = "window-move-to-workspace:2";
        "Mod+Shift+3" = "window-move-to-workspace:3";
        "Mod+Shift+4" = "window-move-to-workspace:4";
        "Mod+Shift+5" = "window-move-to-workspace:5";
        "Mod+Shift+6" = "window-move-to-workspace:6";
        "Mod+Shift+7" = "window-move-to-workspace:7";
        "Mod+Shift+8" = "window-move-to-workspace:8";
        "Mod+Shift+9" = "window-move-to-workspace:9";
      };
    };
  };
}
