# Small CLI utilities. Most have a home-manager `programs.*` module (config +
# fish integration where relevant); the rest are plain packages.
{pkgs, ...}: {
  programs.btop.enable = true;
  programs.bottom.enable = true;
  programs.dircolors.enable = true;
  programs.cava.enable = true;
  programs.fastfetch.enable = true;
  programs.fd.enable = true;
  programs.gpg.enable = true;
  programs.rclone.enable = true;
  programs.ripgrep.enable = true;
  programs.yazi = {
    enable = true;
    # New default as of home-manager 26.05; set explicitly since
    # home.stateVersion here still pins the legacy "yy" default.
    shellWrapperName = "y";
  };
  programs.zoxide.enable = true;

  # tldr: the `tldr` package has no home-manager module, so use tealdeer
  # (the maintained Rust client) instead. Same `tldr` command.
  programs.tealdeer = {
    enable = true;
    settings.updates.auto_update = true;
  };

  home.packages = with pkgs; [
    herdr
    fresh-editor
  ];
}
