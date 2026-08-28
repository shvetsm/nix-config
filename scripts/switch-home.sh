#!/usr/bin/env bash
# Applies the home-manager configuration for the current user@host.
set -euo pipefail
cd "$(dirname "$0")/.."

# -b: when a plain file already sits where home-manager wants to place a
# symlink, move it aside (e.g. foo -> foo.backup) instead of aborting with
# "existing file is in the way".
home-manager switch --flake ".#shvetsm@red-panda" -b backup "$@"
