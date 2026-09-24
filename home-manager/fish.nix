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

      # Helper
      alias lg="lazygit"
      alias xo="xdg-open"
      alias cd="z"

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

	# Zoxide needs this at end of file
	zoxide init fish | source
    '';
  };
}
