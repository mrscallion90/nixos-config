{ pkgs, ... }:
{
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Mullvad VPN
  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  services.flatpak.enable = true; # sober
}
