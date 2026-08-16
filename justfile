# Apply home-manager and the NixOS system configuration
switch: switch-home switch-os

# Apply just the home-manager configuration
switch-home:
    ./scripts/switch-home.sh

# Apply just the NixOS system configuration (needs sudo)
switch-os:
    ./scripts/switch-os.sh

# Check that the flake evaluates cleanly
check:
    nix flake check
