# Wavebox: not in nixpkgs (removed 2025-06-24, unmaintained) and not on
# Flathub, so pin their official AppImage directly and run it through the
# appimage-run wrapper (same mechanism as Moonfin). Bump `version`/`url`/
# `hash` together to update.
{pkgs, ...}: let
  version = "151.2.154-2";
  waveboxAppImage = pkgs.fetchurl {
    url = "https://download.wavebox.app/stable/linux/appimage/Wavebox_${version}_x86_64.AppImage";
    hash = "sha256-GTysqu7ZVTgOJRze83QJndc24VfQLeMIEc/6liD1C9k=";
  };
in {
  home.packages = [
    (pkgs.writeShellScriptBin "wavebox" ''
      exec ${pkgs.appimage-run}/bin/appimage-run ${waveboxAppImage} "$@"
    '')
  ];

  xdg.desktopEntries.wavebox = {
    name = "Wavebox";
    comment = "Productivity browser";
    exec = "wavebox %U";
    icon = "web-browser";
    categories = ["Network" "WebBrowser"];
  };
}
