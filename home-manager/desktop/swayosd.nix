# On-screen display for volume/brightness/mute, triggered by the media-key
# binds in hyprland.nix (`swayosd-client ...`).
{...}: {
  services.swayosd.enable = true;
}
