{ pkgs, ... }:
{
  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  # services.displayManager.ly.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Sway (wayland) alongside Plasma
  programs.sway = {
    enable = true;
    # GTK wrapper support
    wrapperFeatures.gtk = true;
  };

  services.displayManager.sessionPackages = [ pkgs.sway ];

  # udev rules so users in the "video"/"input" groups can control
  # brightness (brightnessctl keybinds in home-manager/sway.nix).
  services.udev.packages = [ pkgs.brightnessctl ];

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
}
