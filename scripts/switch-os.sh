#!/usr/bin/env bash
# Applies the NixOS system configuration. Needs sudo.
set -euo pipefail
cd "$(dirname "$0")/.."

sudo nixos-rebuild switch --flake ".#red-panda" "$@"
