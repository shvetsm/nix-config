# Hyprland desktop: Wayland compositor + login manager.
{...}: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # greetd + regreet, run via cage. Same login-prompter approach as the
  # inspiration config, using nixpkgs' built-in module instead of a hand-rolled
  # wrapper script.
  services.displayManager.regreet.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
