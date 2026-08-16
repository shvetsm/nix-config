#!/usr/bin/env bash
# Applies the home-manager configuration for the current user@host.
set -euo pipefail
cd "$(dirname "$0")/.."

home-manager switch --flake ".#shvetsm@red-panda" "$@"
