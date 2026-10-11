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

    # Ctrl+b, g: Lazygit in current working directory
    bind-key g display-popup -E -w 90% -h 90% -d '#{pane_current_path}' 'lazygit'

    # Ctrl+b, t: Quick CLI in current working directory
    bind-key t display-popup -E -w 80% -h 80% -d '#{pane_current_path}'

    # Ctrl+b, m: rmpc (Music Player Daemon Client) in current working directory
    bind-key m display-popup -E -w 90% -h 90% -d '#{pane_current_path}' 'ncmpcpp'

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
