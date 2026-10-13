{ lib, pkgs, ... }:
let # not in nixpkgs, and TPM is a mess so here were are ig, might as well make tmux.nix at this point
  fzf-pane-switch = pkgs.stdenvNoCC.mkDerivation {
    pname = "fzf-pane-switch";
    version = "2.1.0";

    src = pkgs.fetchFromGitHub {
      owner = "Kristijan";
      repo = "fzf-pane-switch.tmux";
      rev = "v2.1.0";
      hash = "sha256-fpgvCRpiqjDLq9xVCgu/QooxCSurLMj8gv/UOOEGpuY=";
    };

    dontBuild = true;

    installPhase = ''
      mkdir -p $out/share/tmux-plugins/fzf-pane-switch
      cp -r . $out/share/tmux-plugins/fzf-pane-switch/
    '';
  };
in
{

  # Shell scripts
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "tmux-quick-cli" ''
      unset TMUX
      exec ${pkgs.tmux}/bin/tmux new-session -A -s quick-cli
    '')
  ];

  # Need for TTY
  programs.tmux = {
    enable = true;
    extraConfig = ''
    # set -g @tmux_power_theme 'snow'
    set -g @tmux_power_theme 'moon'

    set -g @fzf_pane_switch_bind-key "C-f"

    # No TPM, NixOS does it this way
    run-shell ${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect/resurrect.tmux
    run-shell ${pkgs.tmuxPlugins.continuum}/share/tmux-plugins/continuum/continuum.tmux
    run-shell ${pkgs.tmuxPlugins.power-theme}/share/tmux-plugins/power/tmux-power.tmux
    run-shell ${fzf-pane-switch}/share/tmux-plugins/fzf-pane-switch/select_pane.tmux

    set-option -g status-position top
    set -g mouse on
    set-option -sg escape-time 10 # neovim wants ig
    set-option -g default-terminal "screen-256color" # neovim also wants it

    # Ctrl+b, g: Lazygit in current working directory
    bind-key g display-popup -E -w 90% -h 90% -d '#{pane_current_path}' 'lazygit'

    # make this exec a script, which opens a tmux session (same name), so the state persists
    # Ctrl+b, t: Quick CLI in current working directory
    # bind-key t display-popup -E -w 80% -h 80% -d '#{pane_current_path}'
    bind-key t display-popup -E -w 80% -h 80% -d '#{pane_current_path}' 'tmux-quick-cli'

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
