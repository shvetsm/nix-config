# Fuzzel: dmenu-style app launcher, and the backing menu (--dmenu mode) for
# a handful of other launcher-driven pickers. niri.nix's config.kdl binds
# Mod+D to spawn "fuzzel" for the plain launcher (a fallback alongside
# Noctalia's own Mod+Space launcher, noctalia.nix), plus
# Ctrl+Alt+{E,P,R,W,B,A,C} for the extras below.
# Hyprland's Mod+D uses hyprshell's overview instead (see hyprshell.nix), so
# none of this is wired into hyprland.nix.
{pkgs, ...}: let
  fuzzelClipboard = pkgs.writeShellApplication {
    name = "fuzzel-clipboard";
    runtimeInputs = [pkgs.cliphist pkgs.wl-clipboard];
    text = ''
      cliphist list \
        | fuzzel --dmenu --prompt '󱘢 ' --width 56 \
        | cliphist decode \
        | wl-copy --primary --trim-newline
    '';
  };

  fuzzelHistory = pkgs.writeShellApplication {
    name = "fuzzel-history";
    runtimeInputs = [pkgs.wl-clipboard];
    text = ''
      "$SHELL" -ic history \
        | uniq \
        | fuzzel --dmenu --prompt '󱆃 ' --width 56 \
        | wl-copy --primary --trim-newline
    '';
  };

in {
  home.packages = with pkgs; [
    bemoji # Ctrl+Alt+E: emoji picker, auto-detects fuzzel on PATH
    bzmenu # Ctrl+Alt+B: bluetooth
    iwmenu # Ctrl+Alt+W: wifi
    pwmenu # Ctrl+Alt+A: audio
    hyprpicker # Ctrl+Alt+C: color picker (standalone, no Hyprland IPC needed)
    fuzzelClipboard # Ctrl+Alt+P
    fuzzelHistory # Ctrl+Alt+R
    wl-clipboard
    wtype
  ];

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        filter-desktop = true;
        font = "JetBrainsMono Nerd Font:size=18";
        lines = 16;
        width = 32;
        horizontal-pad = 32;
        vertical-pad = 32;
        inner-pad = 32;
      };
      border = {
        width = 2;
        radius = 8;
      };
    };
  };

  # Backs fuzzel-clipboard. Default systemdTargets (graphical-session.target)
  # covers both the Hyprland (UWSM) and niri sessions.
  services.cliphist.enable = true;
}
