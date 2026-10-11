{ pkgs, ... }:
{
  # Need for TTY
  programs.tmux = {
    enable = true;
    extraConfig = ''
    set-option -g status-position top
    set -g mouse on
    set-option -sg escape-time 10 # neovim wants ig
    set-option -g default-terminal "screen-256color" # neovim also wants it
    '';
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
}
