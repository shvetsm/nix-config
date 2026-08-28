# GTK theming for Thunar and other GTK3/4 apps: Synthwave '84 (dark
# purple/navy + hot-pink/cyan neon accents), same palette as hyprland.nix's
# window borders. Thunar has no per-app theming of its own — it just
# follows the user's GTK theme — and no ready-made Synthwave GTK theme
# exists in nixpkgs, so this recolors Adwaita-dark's named GTK colors
# directly rather than pulling in an unrelated pre-built theme.
{
  pkgs,
  config,
  ...
}: let
  bg = "#241b2f";
  bgAlt = "#2a2139";
  border = "#4a3a5e"; # same as hyprland.nix's inactive_border
  fg = "#f4eee4";
  fgMuted = "#848bbd";
  pink = "#f92aad"; # same as hyprland.nix's active_border
  cyan = "#03edf9"; # same as hyprland.nix's active_border
  yellow = "#fede5d";
  red = "#fe4450";

  # @define-color redefinitions cascade after Adwaita-dark's own, so this
  # only needs to override the named colors it actually uses rather than
  # rewrite the theme's widget CSS.
  synthwaveCss = ''
    @define-color theme_bg_color ${bg};
    @define-color theme_base_color ${bgAlt};
    @define-color theme_fg_color ${fg};
    @define-color theme_text_color ${fg};
    @define-color theme_selected_bg_color ${pink};
    @define-color theme_selected_fg_color ${fg};
    @define-color theme_unfocused_selected_bg_color ${border};
    @define-color theme_unfocused_selected_fg_color ${fg};
    @define-color insensitive_bg_color ${bgAlt};
    @define-color insensitive_fg_color ${fgMuted};
    @define-color borders ${border};
    @define-color unfocused_borders ${border};
    @define-color warning_color ${yellow};
    @define-color error_color ${red};
    @define-color success_color ${cyan};

    /* libadwaita / GTK4 equivalents, for hyprshell and other GTK4 apps. */
    @define-color accent_color ${pink};
    @define-color accent_bg_color ${pink};
    @define-color accent_fg_color ${bg};
    @define-color window_bg_color ${bg};
    @define-color window_fg_color ${fg};
    @define-color view_bg_color ${bgAlt};
    @define-color view_fg_color ${fg};
    @define-color headerbar_bg_color ${bgAlt};
    @define-color headerbar_fg_color ${fg};
    @define-color headerbar_border_color ${border};
    @define-color sidebar_bg_color ${bg};
    @define-color sidebar_fg_color ${fg};

    /* Thunar's pathbar buttons (the breadcrumb path in the toolbar) don't
       pick up theme_selected_bg_color on hover/active, so nudge them
       directly to keep the neon-cyan highlight consistent. */
    .path-bar-box button:hover,
    .path-bar-box button:checked {
      color: ${cyan};
    }
  '';
in {
  gtk = {
    enable = true;

    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };

    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };

    gtk3.extraCss = synthwaveCss;
    gtk4.extraCss = synthwaveCss;
    # Pin to the pre-26.05 default (gtk4 apps use the same theme as gtk3)
    # instead of silently changing behavior at the next stateVersion bump.
    gtk4.theme = config.gtk.theme;
  };
}
