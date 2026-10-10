{ pkgs, ... }:
{
  # Docker for xampp
  virtualisation.docker.enable = true;

  services.flatpak.enable = true; # sober

  # Mullvad VPN
  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };
}
