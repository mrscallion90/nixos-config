{ config, pkgs, lib, ... }:
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
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
  };
  # For the fish shell :)
  programs.fish.enable=true;

  # Also use system packages as well
  home-manager.useGlobalPkgs = true;

  # Home manager
  home-manager.users.user = { pkgs, ... }: {
    home = {
      # Enviroment variables
      sessionVariables = {
        EDITOR = "hx";
      };   

      # Programs with no configs
      packages = with pkgs; [
        # Packages in root enviroment already: helix, tmux
        # unstable.pkg
        # Work
        libreoffice-still

        # Internet
        librewolf brave

        # CLI Stuff
        mpv yt-dlp ffmpeg
        tree fzf wl-clipboard
        zoxide

        # Password Manager
        bitwarden-desktop

        # Development
        lazygit git

        # Gaming
        steam lutris protonplus
      ];
    };

    # Programs with config (in their own directory maybe?)
    programs.fish = {
      enable = true; # Need this to load the config below, dunno why but yeah
      interactiveShellInit = ''
        set fish_greeting # Disable greeting

        # nixos stuff
        alias nixos-rebuild-shortcut="doas nixos-rebuild switch -I nixos-config=$HOME/nixos-config/configuration.nix"
        alias nixos-config="$EDITOR $HOME/nixos-config"

        # Helper
        alias lg="lazygit"
        alias xo="xdg-open"

        # Mullvad
        alias mullvad-on='mullvad lockdown-mode set on && mullvad connect'
        alias mullvad-off='mullvad lockdown-mode set off && mullvad disconnect'
        alias mullvad-info='mullvad status && mullvad dns get'

        function music-dl -a ytlink
          set --local WORK_DIR $(pwd)
          cd $(realpath $HOME/Music/* | fzf --prompt "Music Folder to download to:  ")
          yt-dlp -f bestaudio -x "$ytlink"
          cd "$WORK_DIR"
        end

        function music-play
          mpv --shuffle --loop-playlist $(realpath $HOME/Music/* | fzf --prompt "Music Folder: ")
        end

        # Autologins into tmux
        if status is-interactive
            and not set -q TMUX
            # and not set -q KONSOLE_DBUS_SESSION # <-- skip if inside Yakuake, Konsole
            if tmux has-session -t larp
                exec tmux attach-session -t larp
            else
                tmux new-session -s larp
            end
        end
      '';
    };

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "26.05"; # DONT CHANGE
  };
}
