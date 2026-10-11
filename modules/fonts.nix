{ pkgs, ... }:
{
  fonts.packages = with pkgs.nerd-fonts; [
    iosevka
    fantasque-sans-mono
  ];
}
