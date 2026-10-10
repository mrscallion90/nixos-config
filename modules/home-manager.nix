{ pkgs, ... }:
let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-26.05.tar.gz;
in
{
  imports =
    [
      "${home-manager}/nixos"
    ];

  # User setup
  users.users.user = {
    isNormalUser = true;
    description = "user";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.fish;
  };

  # Also use system packages seetings as well
  home-manager.useGlobalPkgs = true;

  # Home manager
  home-manager.users.user = {
    imports = [
      ../home/base.nix
    ];
  };
}
