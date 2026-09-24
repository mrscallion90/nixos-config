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
  programs.fish.enable = true;

  # Also use system packages as well
  home-manager.useGlobalPkgs = true;

  # Home manager
  home-manager.users.user = {
    imports = [
      ./fish.nix
      ./neovim.nix
      ./sway.nix
      ./opencode.nix
    ];

    home = {
      # Enviroment variables
      sessionVariables = {
        # EDITOR = "hx";
        EDITOR = "nvim";
      };

      # Programs with no configs
      packages = with pkgs; [
        # Packages in root enviroment already: helix, tmux
        # unstable.pkg

        # Messaging
        telegram-desktop discord #whatsapp can installed as webapp from brave

        # School
        wine #davinci look

        #iot
        cisco-packet-tracer_9
        (python313.withPackages (python-pkgs: with python-pkgs; [
          # select Python packages here
          psutil
        ]))

        #fyp
        blender godot_4_7 # u just change godot version manually

        # Work
        libreoffice-still
        kdePackages.kolourpaint

        # Internet
        librewolf brave

        # CLI Stuff
        mpv yt-dlp ffmpeg
        tree fzf wl-clipboard tldr
        zoxide

        # Password Manager
        bitwarden-desktop

        # Development
        ollama # Local AI/MCP stuff | qwen2.5:7b
        nodejs_22 pnpm # npx for deepseek-harness
        ungoogled-chromium
        lazygit git
        nim nimble # dnd-nim
        # Neovim LSP
        superhtml pyright nimlangserver

        # Cool magic system stuff
        lean4

        # Gaming
        steam lutris protonplus
      ];
    };

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "26.05"; # DONT CHANGE
  };
}
