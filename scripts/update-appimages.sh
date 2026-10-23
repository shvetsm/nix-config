#!/usr/bin/env bash
# Bumps the pinned AppImages (home-manager/{wavebox,logseq}.nix) to their
# latest upstream release: resolves the newest version, prefetches it, and
# rewrites `version` and `hash` in place. Doesn't apply anything; run
# `just switch-home` afterwards (or use `just update-appimages`).
set -euo pipefail
cd "$(dirname "$0")/.."

# Follows a redirect without downloading and prints where it points.
redirect_target() {
  curl -fsSI "$1" | tr -d '\r' | awk 'tolower($1) == "location:" {print $2}'
}

# update <nix file> <latest version> <url for that version>
update() {
  local file=$1 latest=$2 url=$3 current hash
  current=$(sed -n 's/^ *version = "\(.*\)";/\1/p' "$file")
  if [[ -z $latest ]]; then
    echo "$file: couldn't determine latest version, skipping" >&2
    return
  fi
  if [[ $current == "$latest" ]]; then
    echo "$file: $current is already the latest"
    return
  fi
  echo "$file: $current -> $latest"
  hash=$(nix store prefetch-file --json "$url" | sed -n 's/.*"hash":"\([^"]*\)".*/\1/p')
  sed -i \
    -e "s|^\( *version = \)\".*\";|\1\"$latest\";|" \
    -e "s|^\( *hash = \)\".*\";|\1\"$hash\";|" \
    "$file"
}

# Wavebox: the "latest" URL redirects to the versioned AppImage.
wavebox_latest=$(redirect_target https://download.wavebox.app/latest/stable/linux/appimage |
  sed -n 's|.*/Wavebox_\(.*\)_x86_64\.AppImage$|\1|p')
update home-manager/wavebox.nix "$wavebox_latest" \
  "https://download.wavebox.app/stable/linux/appimage/Wavebox_${wavebox_latest}_x86_64.AppImage"

# Logseq: GitHub's releases/latest redirects to the newest non-prerelease tag.
logseq_latest=$(redirect_target https://github.com/logseq/logseq/releases/latest |
  sed -n 's|.*/releases/tag/||p')
update home-manager/logseq.nix "$logseq_latest" \
  "https://github.com/logseq/logseq/releases/download/${logseq_latest}/Logseq-linux-x86_64-${logseq_latest}.AppImage"
