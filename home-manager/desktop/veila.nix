# Veila: Wayland-native screen locker (replaces hyprlock), same tool the
# inspiration config uses. Config is pared down from theirs — no fingerprint,
# avatar, weather, or now-playing widgets — and themed to Synthwave '84
# instead of Catppuccin.
{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  veila = inputs.veila.packages.${pkgs.stdenv.hostPlatform.system}.default;
  veiladBin = lib.getExe' veila "veilad";
  veilaBin = lib.getExe' veila "veila";
  passEnvironment = "WAYLAND_DISPLAY XDG_SESSION_ID XDG_SESSION_TYPE XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE";
  veilaConfig = ''
    theme = "catppuccin"

    [lock]
    hide_cursor = false
    allow_empty_password = false

    [visuals.input]
    placeholder = "󰌋"
    font_family = "JetBrainsMono Nerd Font"
    font_size = 30
    mask_color = "#f9f9f9"
    background_color = "rgba(38, 35, 53, 1.0)"
    border_color = "#b93cf6"
    border_width = 2
    radius = 8

    [visuals.placeholder]
    color = "#f92aad"

    [visuals.eye]
    enabled = false

    [visuals.caps_lock]
    enabled = true

    [visuals.keyboard]
    enabled = false
  '';
in {
  home.packages = [veila];

  xdg.configFile."veila/config.toml".text = veilaConfig;

  systemd.user.services = {
    veilad = {
      Unit = {
        Description = "Veila screen locker daemon";
        After = ["graphical-session.target"];
        PartOf = ["graphical-session.target"];
        X-Restart-Triggers = [(builtins.hashString "sha256" veilaConfig)];
      };
      Service = {
        Type = "simple";
        Environment = [
          "HOME=${config.home.homeDirectory}"
          "XDG_CACHE_HOME=${config.home.homeDirectory}/.cache"
        ];
        ExecStart = veiladBin;
        Restart = "on-failure";
        RestartSec = 2;
        PassEnvironment = passEnvironment;
      };
      Install.WantedBy = ["graphical-session.target"];
    };
    veila-idle = {
      Unit = {
        Description = "Veila idle and sleep lock monitor";
        After = ["graphical-session.target" "veilad.service"];
        PartOf = ["graphical-session.target"];
      };
      Service = {
        Type = "simple";
        Environment = [
          "VEILA_IDLE_LOCK_AFTER=300"
          "VEILA_IDLE_SLEEP_FLAG=--lock-before-sleep"
        ];
        ExecStart = "${veilaBin} idle --lock-after=\${VEILA_IDLE_LOCK_AFTER} $VEILA_IDLE_SLEEP_FLAG";
        Restart = "on-failure";
        RestartSec = 2;
        PassEnvironment = passEnvironment;
      };
      Install.WantedBy = ["graphical-session.target"];
    };
  };

  wayland.windowManager.hyprland.settings.bind = [
    {
      _args = [
        "SUPER + L"
        (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${veilaBin} lock\")")
      ];
    }
  ];
}
