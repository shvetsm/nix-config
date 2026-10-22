# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    ./desktop.nix
    ./fonts.nix

    inputs.noctalia-greeter.nixosModules.default
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
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = [ "nix-command" "flakes" ];
      # Opinionated: disable global registry
      flake-registry = "";
    };
    # Opinionated: disable channels
    channel.enable = false;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "red-panda";
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ 8090 3456 ];

  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Desktop (Hyprland + SDDM) lives in ./desktop.nix

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Canon LBP646C on the LAN. Uses CUPS's built-in IPP Everywhere ("everywhere")
  # driver rather than Canon's proprietary UFRII blob, since this printer
  # supports driverless AirPrint/Mopria printing.
  hardware.printers = {
    ensureDefaultPrinter = "Canon_LBP646C";
    ensurePrinters = [
      {
        name = "Canon_LBP646C";
        description = "Canon LBP646C";
        deviceUri = "ipp://192.168.8.105/ipp/print";
        model = "everywhere";
      }
    ];
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # fingerprint reader
  services.fprintd.enable = true;

  # fprintAuth defaults to on for every PAM service once fprintd is enabled
  # (incl. "login" — both sddm's and greetd's PAM stacks substack into it).
  # pam_fprintd runs before pam_unix, so the password prompt is gated behind
  # it: a failed/slow scan makes the greeter look hung for ~25s before
  # falling back to password. Keep fingerprint for sudo and the lock screen;
  # login stays password-only.
  security.pam.services.login.fprintAuth = false;

  programs.fish.enable = true;

  users.users.shvetsm = {
    isNormalUser = true;
    description = "Mark Shvets";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.fish;
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Steam (also sets up 32-bit graphics, udev rules for controllers, etc.)
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    ghostty
    zed-editor
    usbutils
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "26.05";
}
