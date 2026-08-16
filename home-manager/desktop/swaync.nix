# swaync: notification daemon + panel, themed to match Synthwave '84.
{...}: {
  services.swaync = {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "top";
      control-center-margin-top = 8;
      control-center-margin-right = 8;
      control-center-margin-bottom = 8;
      notification-window-width = 380;
      timeout = 6;
    };
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
      }

      .control-center {
        background: #262335;
        border: 1px solid #b93cf6;
        border-radius: 8px;
      }

      .notification-row .notification-background {
        background: #262335;
        border: 1px solid #b93cf6;
        border-radius: 6px;
        color: #f9f9f9;
      }

      .notification-content {
        color: #f9f9f9;
      }

      .close-button {
        background: #f92aad;
        color: #f9f9f9;
        border-radius: 4px;
      }

      .close-button:hover {
        background: #ff8b39;
      }

      .notification-action {
        background: #3b2f4d;
        color: #f9f9f9;
        border: 1px solid #03edf9;
      }

      .notification-action:hover {
        background: #03edf9;
        color: #262335;
      }

      .widget-title {
        color: #f9f9f9;
      }

      .widget-title > label {
        color: #03edf9;
        font-weight: bold;
      }

      .widget-title > button {
        background: #3b2f4d;
        color: #f9f9f9;
      }
    '';
  };
}
