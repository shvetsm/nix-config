# Desktop UI: Hyprland compositor + waybar pager. Kept in its own space so it
# can grow (notifications, lock screen, wallpaper, theming) without cluttering
# the top-level home.nix.
{...}: {
  imports = [
    ./hyprland.nix
    ./hyprshell.nix
    ./fuzzel.nix
    ./ghostty.nix
    ./niri.nix
    ./noctalia.nix
    ./swayosd.nix
  ];
}
