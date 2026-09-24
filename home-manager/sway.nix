{ ... }:
{
  wayland.windowManager.sway = {
    enable = true;
    package = null;
    systemd.enable = true;

    config = {
      modifier = "Mod4";
      terminal = "konsole";
      input = {
        "type:touchpad" = {
          # Enables or disables tap for specified input device.
          tap = "enabled";
          # Enables or disables natural (inverted) scrolling for the specified input device.
          natural_scroll = "enabled";
          # Enables or disables disable-while-typing for the specified input device.
          dwt = "enabled";
        };
      };

      # startup = [
      #  { command = "konsole"; }
      # ];
    };
  };
}
