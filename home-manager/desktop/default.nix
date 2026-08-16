# Desktop UI: Hyprland compositor + waybar pager. Kept in its own space so it
# can grow (notifications, lock screen, wallpaper, theming) without cluttering
# the top-level home.nix.
{...}: {
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./fuzzel.nix
    ./swaync.nix
    ./veila.nix
    ./wlogout.nix
  ];
}
