# Logseq: nixpkgs' package bundles an EOL/insecure electron build, so pin
# their official AppImage directly and run it through the appimage-run
# wrapper (same mechanism as Wavebox). Bump `version`/`url`/`hash` together
# to update.
{pkgs, ...}: let
  version = "2.0.1";
  logseqAppImage = pkgs.fetchurl {
    url = "https://github.com/logseq/logseq/releases/download/${version}/Logseq-linux-x86_64-${version}.AppImage";
    hash = "sha256-Sd42cHizdnD+vbmH5WK3Xe4eGulsKL+4c4d5xCKX3Qw=";
  };
in {
  home.packages = [
    (pkgs.writeShellScriptBin "logseq" ''
      exec ${pkgs.appimage-run}/bin/appimage-run ${logseqAppImage} "$@"
    '')
  ];

  xdg.desktopEntries.logseq = {
    name = "Logseq";
    comment = "Privacy-first, open-source knowledge management platform";
    exec = "logseq %U";
    icon = "logseq";
    categories = ["Office" "Utility"];
  };
}
