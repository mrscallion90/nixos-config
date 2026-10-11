{ config, pkgs, ... }:
let
  home-manager    = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-26.05.tar.gz;
  unstableTarball = builtins.fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
in
{
  imports =
    [
      "${home-manager}/nixos"
    ];

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

  # User setup
  users.users.user = {
    isNormalUser = true;
    description = "user";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.fish;
  };

  #Virtualbox
  users.extraGroups.vboxusers.members = [ "user" ];

  # For the fish shell :)
  programs.fish.enable = true;

  # Also use system packages seetings as well
  home-manager.useGlobalPkgs = true;

  # Home manager
  home-manager.users.user = {

    imports = [
      ./packages.nix
      ./fish.nix
      ./neovim.nix
      ./sway.nix
      ./opencode.nix
      ./music-player-daemon.nix
    ];

    home = {
      # Enviroment variables
      sessionVariables = {
        # EDITOR = "hx";
        EDITOR = "nvim";
      };
    };

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "26.05"; # DONT CHANGE
  };
}
