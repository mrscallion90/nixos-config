{ pkgs, ... }:
{
  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  # services.displayManager.ly.enable = true;
  services.desktopManager.plasma6.enable = true;

  programs.sway = {
    enable = true;
    # GTK wrapper support
    wrapperFeatures.gtk = true;
  };

  services.displayManager.sessionPackages = [ pkgs.sway ];

  services.libinput = {
    enable = true;
    # Touchpad
    touchpad = {
      naturalScrolling = true; # Enables Natural scrolling
      accelProfile = "flat";   # Disables mouse acceleration
    };

    # Mouse
    mouse = {
      naturalScrolling = true; # Enables Natural scrolling
      accelProfile = "flat";   # Disables mouse acceleration
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
}
