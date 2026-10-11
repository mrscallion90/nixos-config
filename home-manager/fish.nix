{ ... }:
{
  programs.fish = {
    enable = true; # Need this to load the config below, dunno why but yeah
    interactiveShellInit = ''
      set fish_greeting # Disable greeting

      #school stuff
      alias davinci-look="env WINEPREFIX=/home/user/misc/davinci-look/wine-prefix/ wine /home/user/misc/davinci-look/wine-prefix/drive_c/Stueber\ Software/daVinci\ 3\ Look/daVinciLook.exe"

      # nixos stuff
      alias nixos-rebuild-shortcut="doas nixos-rebuild switch -I nixos-config=$HOME/nixos-config/configuration.nix"
      alias nixos-config="$EDITOR $HOME/nixos-config"
      alias nix-search="nix search nixpkgs $argv"

      # Helper
      alias lg="lazygit"
      alias xo="xdg-open"
      alias cd="z"

      # Aesthetics
      alias ls="eza --icons --git"
      alias la="eza --icons --git -a"
      alias ll="eza --icons --git -l"
      alias grep="rg"
      alias cat="bat"
      alias less="bat"
      # no fd for find, fd is shorter than find

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

      # End of file init
      zoxide init fish | source
      starship init fish | source
      fastfetch
    '';
  };


  programs.starship = {
    enable = true;
    presets = [ "bracketed-segments" ];
    settings = {
      add_newline = true;
      command_timeout = 1300;
      scan_timeout = 50;
      # format = "$all$nix_shell$nodejs$lua$golang$rust$php$git_branch$git_commit$git_state$git_status$dotnet$docker_context\n$username$hostname$directory";
      character = {
        success_symbol = "[](bold green) ";
        error_symbol = "[✗](bold red) ";
      };
    };
  };

}
