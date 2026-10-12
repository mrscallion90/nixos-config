{ ... }:
{
  # Nix-command & flakes is still in beta despite widely used so uhh..
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Unfree packages
  nixpkgs.config.allowUnfree = true;

  # Garbage collector
  nix.gc = {
    automatic = true;
    dates = "weekly"; # Runs every week
    options = "--delete-older-than 14d"; # Deletes generations older than 14 days
  };
}
