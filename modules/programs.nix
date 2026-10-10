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

  # For the fish shell :)
  programs.fish.enable = true;
}
