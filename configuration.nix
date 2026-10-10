# NixOS entry point. Everything is imported from ./modules; host-specific
# hardware lives in ./hardware-configuration.nix (generated, do not edit).
#
# Apply with:  doas nixos-rebuild switch -I nixos-config=$HOME/nixos-config/configuration.nix
{ config, pkgs, ... }:
let
  nixos-hardware = builtins.fetchTarball https://github.com/NixOS/nixos-hardware/archive/master.tar.gz;
in
{
  imports =
    [ # Include the results of the hardware scan (host-specific).
      "${nixos-hardware}/lenovo/ideapad/15alc6"
      ./hardware-configuration.nix

      # System modules
      ./modules/boot.nix
      ./modules/networking.nix
      ./modules/localization.nix
      ./modules/hardware.nix
      ./modules/security.nix
      ./modules/nix.nix
      ./modules/packages.nix
      ./modules/programs.nix
      ./modules/desktop.nix
      ./modules/services.nix
      ./modules/audio.nix
      ./modules/home-manager.nix
    ];

  # ---------------------
  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}
