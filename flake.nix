{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Hardware-specific NixOS modules
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    claude-code.url = "github:sadjow/claude-code-nix";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    claude-code,
    ...
  } @ inputs: let
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#red-panda'
    nixosConfigurations = {
      red-panda = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        # > Our main nixos configuration file <
        modules = [./nixos/configuration.nix];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#shvetsm@red-panda'
    homeConfigurations = {
      "shvetsm@red-panda" = home-manager.lib.homeManagerConfiguration {
        # Home-manager requires 'pkgs' instance
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs;};
        # > Our main home-manager configuration file <
        modules = [./home-manager/home.nix];
      };
    };
  };
}
