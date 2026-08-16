# System fonts: a Nerd Font for terminal/waybar icons, Inter for UI text.
{pkgs, ...}: {
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    inter
  ];

  fonts.fontconfig.defaultFonts = {
    sansSerif = ["Inter"];
    monospace = ["JetBrainsMono Nerd Font"];
  };
}
