{ ... }:
{
  services.mpd = {
    enable = true;

    musicDirectory = "/home/user/Music";

    extraConfig = ''
      audio_output {
        type "pipewire"
        name "PipeWire"
      }
    '';
  };

  programs.ncmpcpp = {
    enable = true;

    settings = {
      # Show filenames instead of artist/title metadata.
      song_list_format = "%f";
      song_library_format = "%f";
      song_status_format = "%f";

      # Sort the browser by filename.
      browser_sort_mode = "name";

      # Keep the queue in a simple list.
      playlist_display_mode = "classic";
      browser_display_mode = "classic";
    };
  };


}
