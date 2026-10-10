{ config, pkgs, ... }:
let
  # Unstable packages
  unstableTarball =
    builtins.fetchTarball
      https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
in
{
  nixpkgs.config = {
    # Allow unfree packages
    allowUnfree = true;

    # Allow unstable packages
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages

    # filmcraft & photocraft
    libGL vulkan-loader # graphic libraries
    libxcb libxkbcommon  # keyboard
    libX11 libXcursor libXi libXrandr #xorg/x11
    wayland  # wayland
    alsa-lib  # audio
  ];

  # Nix-command & flakes is still in beta despite widely used so uhh..
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Garbage collector
  nix.gc = {
    automatic = true;
    dates = "weekly"; # Runs every week
    options = "--delete-older-than 14d"; # Deletes generations older than 14 days
  };
}
