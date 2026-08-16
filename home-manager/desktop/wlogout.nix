# wlogout: fullscreen power menu (lock/logout/reboot/shutdown/suspend),
# launched from the waybar power button. Themed to match Synthwave '84.
{...}: {
  programs.wlogout = {
    enable = true;

    layout = [
      {
        label = "lock";
        action = "veila lock";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "logout";
        action = "hyprctl dispatch exit";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
    ];

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 16px;
      }

      window {
        background: rgba(38, 35, 53, 0.9);
      }

      button {
        background-color: #262335;
        border: 2px solid #b93cf6;
        border-radius: 8px;
        color: #f9f9f9;
        margin: 10px;
      }

      button:focus,
      button:active,
      button:hover {
        background-color: #3b2f4d;
        border-color: #f92aad;
      }
    '';
  };
}
