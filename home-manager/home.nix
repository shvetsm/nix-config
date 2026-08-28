# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    ./desktop
    ./cli-tools.nix
    ./fish.nix
    ./git.nix
    ./logseq.nix
    ./vscode.nix
    ./wavebox.nix
    ./zellij.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
       inputs.claude-code.overlays.default
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  home = {
    username = "shvetsm";
    homeDirectory = "/home/shvetsm";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    (appimage-run.override {
      extraPkgs = pkgs: [pkgs.libepoxy pkgs.xorg.libXv];
    })
    claude-code
    deskflow
    enpass
    gimp
    just
    lan-mouse
    nwg-displays
    # Electron's Tray silently no-ops on Linux without libayatana-appindicator
    # on the library path (no error, it just never registers a
    # StatusNotifierItem), so its icon never reaches Noctalia's tray widget.
    (pear-desktop.overrideAttrs (old: {
      postFixup =
        (old.postFixup or "")
        + ''
          wrapProgram $out/bin/pear-desktop \
            --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [libayatana-appindicator]}
        '';
    }))
    slack
  ];

  # Enable home-manager (git is configured in git.nix)
  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.11";
}
