{ ... }:
{
  networking.hostName = "LAPTOP-7JHF90"; # Define your hostname.

  # Enable networking
  networking.networkmanager = {
    enable = true;

    # Device MAC Address spoofing
    settings = {
      main = {
        "dhcp" = "internal";
      };
      device = {
        "wifi.scan-rand-mac-address" = true;
      };

      connection = {
        "ipv4.dhcp-send-hostname=false";
        "ipv6.dhcp-send-hostname=false";
        "wifi.cloned-mac-address" = "random";
        "ethernet.cloned-mac-address" = "random";
        "match-device" = "type:wifi";
      };
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

}
