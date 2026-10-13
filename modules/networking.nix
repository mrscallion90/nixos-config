{ ... }:
{
  networking.hostName = "LAPTOP-7JHF90"; # Define your hostname.

  # Enable networking
  networking.networkmanager = {
    enable = true;

    # Device MAC Address spoofing
    settings = {
      device = {
        "wifi.scan-rand-mac-address" = true;
      };

      connection = {
        "wifi.cloned-mac-address" = "random";
        "ethernet.cloned-mac-address" = "random";
      };
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

}
