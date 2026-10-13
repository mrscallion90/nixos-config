# vibecoded mess
# treat it as magical file hidden away as one file
# prolly have ai clean it up tho


{ config, pkgs, lib, ... }:
let
  # Single source of truth for the window manager modifier.
  modifier = "Mod4";

  # ------------------------------------------------------------------
  # Helper scripts (kept here so the whole sway setup stays one file)
  # ------------------------------------------------------------------

  # Restore the last wallpaper picked by the user (or a sane default) on
  # every sway start. The chosen path is persisted in the cache dir.
  wallpaperRestore = pkgs.writeShellScript "sway-wallpaper-restore" ''
    set -eu
    cache="''${XDG_CACHE_HOME:-$HOME/.cache}/wallpaper"
    img=""
    if [ -f "$cache/current" ]; then
      img="$(cat "$cache/current")"
    fi
    if [ -z "$img" ] || [ ! -f "$img" ]; then
      # Falls back to the wallpaper shipped by the NixOS sway module.
      img="$(ls /run/current-system/sw/share/backgrounds/sway/* 2>/dev/null | head -n1 || true)"
    fi
    ${pkgs.procps}/bin/pkill -x swaybg 2>/dev/null || true
    if [ -n "$img" ] && [ -f "$img" ]; then
      exec ${pkgs.swaybg}/bin/swaybg -i "$img" -m fill
    fi
  '';

  # Pick a wallpaper, apply it, persist the choice and regenerate the
  # whole colorscheme from it (pywal -> waybar colors.css).
  wallpaperPicker = pkgs.writeShellScript "sway-wallpaper-picker" ''
    set -eu
    dir="$HOME/Pictures/Wallpapers"
    cache="''${XDG_CACHE_HOME:-$HOME/.cache}/wallpaper"
    mkdir -p "$cache"
    mapfile -t files < <(find "$dir" -type f \
      \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' \) \
      2>/dev/null | sort)
    if [ "''${#files[@]}" -eq 0 ]; then
      ${pkgs.libnotify}/bin/notify-send "Wallpaper" "No wallpapers found in $dir"
      exit 0
    fi
    choice="$(printf '%s\n' "''${files[@]}" | \
      ${pkgs.wofi}/bin/wofi --show dmenu --prompt 'Wallpaper' --width 700)" || true
    [ -n "$choice" ] || exit 0
    printf '%s\n' "$choice" > "$cache/current"
    ${pkgs.procps}/bin/pkill -x swaybg 2>/dev/null || true
    ${pkgs.swaybg}/bin/swaybg -i "$choice" -m fill &
    # Generate the colorscheme from the new wallpaper (skip setting the
    # wallpaper, swaybg already did that).
    ${pkgs.pywal}/bin/wal -i "$choice" -n -q 2>/dev/null || true
    if [ -f "$HOME/.cache/wal/colors-waybar.css" ]; then
      cp -f "$HOME/.cache/wal/colors-waybar.css" "$HOME/.config/waybar/colors.css"
    fi
    ${pkgs.procps}/bin/pkill -SIGUSR2 waybar 2>/dev/null || true
  '';

  # Toggle the night light (wlsunset) user service.
  nightLightToggle = pkgs.writeShellScript "sway-night-light-toggle" ''
    if systemctl --user is-active --quiet wlsunset; then
      systemctl --user stop wlsunset
    else
      systemctl --user start wlsunset
    fi
  '';
in
{
  wayland.windowManager.sway = {
    enable = true;
    package = null;
    systemd.enable = true;

    config = {
      modifier = modifier;
      terminal = "kitty";
      menu = "${pkgs.wofi}/bin/wofi --show drun";

      # Disable sway's built-in bar: waybar is used instead.
      bars = [ ];

      fonts = {
        names = [
          "FantasqueSansM Nerd Font"
          "Symbols Nerd Font"
        ];
        size = 11.0;
      };

      # Minimal + clean look.
      window = {
        titlebar = false;
        border = 2;
        hideEdgeBorders = "smart";
      };

      floating = {
        titlebar = false;
        border = 1;
        criteria = [
          { app_id = "pavucontrol"; }
          { app_id = "blueman-manager"; }
        ];
      };

      gaps = {
        inner = 6;
        outer = 10;
      };

      colors = {
        focused = {
          border = "#589df6";
          background = "#0e1420";
          text = "#e6edf3";
          indicator = "#589df6";
          childBorder = "#589df6";
        };
        focusedInactive = {
          border = "#0e1420";
          background = "#0e1420";
          text = "#e6edf3";
          indicator = "#0e1420";
          childBorder = "#0e1420";
        };
        unfocused = {
          border = "#1b2333";
          background = "#0e1420";
          text = "#9aa7b8";
          indicator = "#1b2333";
          childBorder = "#0e1420";
        };
        urgent = {
          border = "#ff6b6b";
          background = "#0e1420";
          text = "#ffffff";
          indicator = "#ff6b6b";
          childBorder = "#ff6b6b";
        };
        background = "#0e1420";
      };

      input = {
        "type:touchpad" = {
          # Enables or disables tap for specified input device.
          tap = "enabled";
          # Enables or disables natural (inverted) scrolling.
          natural_scroll = "enabled";
          # Enables or disables disable-while-typing.
          dwt = "enabled";
        };
      };

      startup = [
        { command = "${wallpaperRestore}"; }
        { command = "${pkgs.mako}/bin/mako"; }
      ];

      # Extend (not replace) the default keybindings.
      keybindings = lib.mkOptionDefault {
        # Audio (WirePlumber / pipewire).
        "XF86AudioRaiseVolume" =
          "exec ${pkgs.wireplumber}/bin/wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+";
        "XF86AudioLowerVolume" =
          "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        "XF86AudioMute" =
          "exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "XF86AudioMicMute" =
          "exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";

        # Backlight.
        "XF86MonBrightnessUp" =
          "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%+";
        "XF86MonBrightnessDown" =
          "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";

        # Screenshot (region -> clipboard).
        "Print" =
          "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy";

        # Wallpaper picker + colorscheme regeneration.
        "${modifier}+Shift+w" = "exec ${wallpaperPicker}";
        # Night light toggle.
        "${modifier}+Shift+n" = "exec ${nightLightToggle}";
      };
    };
  };

  # ------------------------------------------------------------------
  # Waybar: one process, three floating "glass" islands (left/center/right)
  # ------------------------------------------------------------------
  programs.waybar = {
    enable = true;

    systemd = {
      enable = true;
      targets = [ "sway-session.target" ];
    };

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 34;
        spacing = 6;
        # Ask the compositor for a blurred background behind the bar
        # (no-op on sway, kept for compositors that support it).
        blur = true;

        output = [
          "eDP-1" # Built-in Laptop Monitor
          # "HDMI-A-1"
        ];

        modules-left = [ 
          "sway/workspaces" 
          "mpd"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "memory"
          "wireplumber"
          "network"
          "bluetooth"
          "backlight"
          "battery"
        ];

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{name}";
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "10" = "10";
            urgent = "!";
            focused = "●";
            default = "○";
          };
        };

        memory = {
          format = "Mem {used}/{total}";
        };

        mpd = {
          format = "{filename}";
          format-paused = "󰏤 {filename}";
          format-stopped = "";
          tooltip = false;
        };

        clock = {
          format = "{:%A - %d-%m-%Y - %H:%M}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          # tooltip-format = "{:%a, %d %b %y}";
        };

        wireplumber = {
          format = "{icon} {volume}";
          format-muted = "󰝟";
          format-icons = [ "󰕿" "󰖀" "󰕾" ];
          tooltip = false;
        };

        network = {
          format-wifi = "󰤨  {essid}";
          format-ethernet = "󰈀";
          format-disconnected = "󰤭";
          tooltip = false;
        };

        bluetooth = {
          format = "󰂯 On";
          format-disabled = "󰂲 Nil";
          format-off = "󰂲 Off";
          tooltip = false;
        };

        backlight = {
          format = "{icon}  {percent}";
          format-icons = [ "󰃞" "󰃟" "󰃠" ];
          tooltip = false;
        };

        battery = {
          format = "{icon} {capacity}";
          format-charging = "󰂄";
          format-plugged = "󰚥";
          format-icons = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          tooltip = false;
        };
      };
    };

    # Glass + minimal. The left/center/right module groups are styled as
    # three separate floating bars instead of one continuous strip.
    style = ''
      @import url("/home/user/.config/waybar/colors.css");

      * {
        border: none;
        border-radius: 0;
        min-height: 0;
        font-family: "FantasqueSansM Nerd Font Mono", "Symbols Nerd Font", monospace;
        font-size: 14px;
      }

      window#waybar {
        background: transparent;
        color: @foreground;
      }

      /* Three separated glass bars. */
      .modules-left,
      .modules-center,
      .modules-right {
        background: alpha(@background, 0.55);
        border: 1px solid alpha(@foreground, 0.12);
        border-radius: 14px;
        margin: 8px 6px;
        padding: 0 10px;
      }

      #workspaces {
        padding: 0;
        margin: 0;
      }

      #workspaces button {
        padding: 0 6px;
        margin: 4px 2px;
        border-radius: 10px;
        background: transparent;
        color: alpha(@foreground, 0.55);
      }

      #workspaces button:hover {
        background: alpha(@foreground, 0.12);
        color: @foreground;
      }

      #workspaces button.active,
      #workspaces button.focused {
        background: alpha(@foreground, 0.9);
        color: @background;
      }

      #workspaces button.urgent {
        background: @color1;
        color: @background;
      }

      #clock,
      #mpd,
      #memory,
      #wireplumber,
      #network,
      #bluetooth,
      #backlight,
      #battery {
        padding: 0 8px;
        color: @foreground;
      }

      #battery.charging,
      #battery.plugged {
        color: @color2;
      }

      #battery.warning {
        color: @color3;
      }

      #battery.critical {
        color: @color1;
      }

      #network.disconnected,
      #bluetooth.off,
      #bluetooth.disabled {
        color: alpha(@foreground, 0.35);
      }

      tooltip {
        background: alpha(@background, 0.95);
        border: 1px solid alpha(@foreground, 0.15);
        border-radius: 10px;
      }

      tooltip label {
        color: @foreground;
      }
    '';
  };

  # Notifications.
  services.mako = {
    enable = true;
    settings = {
      anchor = "top-right";
      layer = "overlay";
      margin = 12;
      padding = "12";
      width = 340;
      height = 120;
      border-size = 2;
      border-radius = 12;
      border-color = "#ffffff22";
      background-color = "#0e1420e6";
      text-color = "#e6edf3";
      font = "FantasqueSansM Nerd Font 12";
      default-timeout = 6000;
      icons = true;
      markup = true;
    };
  };

  # Night light (day/night gamma/temperature).
  services.wlsunset = {
    enable = true;
    temperature = {
      day = 6500;
      night = 4000;
    };
    sunrise = "07:00";
    sunset = "19:00";
  };

  # Wayland session environment, inherited by sway and everything it spawns.
  # Without GDK_BACKEND=wayland, GTK apps (wofi) pick XWayland where
  # gtk-layer-shell cannot create a surface.
  home.sessionVariables = {
    GDK_BACKEND = "wayland";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  # Application launcher: glass, and colorscheme-aware via the pywal palette.
  programs.wofi = {
    enable = true;
    settings = {
      location = "center";
      width = 620;
      prompt = "Search";
      allow_images = true;
      image_size = 24;
      hide_scroll = true;
      matching = "fuzzy";
      insensitive = true;
      dynamic_lines = true;
    };
    style = ''
      @import url("/home/user/.config/waybar/colors.css");

      * {
        font-family: "FantasqueSansM Nerd Font", "Symbols Nerd Font", monospace;
        font-size: 15px;
      }

      window {
        background-color: alpha(@background, 0.72);
        border: 1px solid alpha(@foreground, 0.12);
        border-radius: 18px;
        box-shadow: 0 12px 32px alpha(@background, 0.55);
        padding: 6px;
      }

      #input {
        margin: 10px;
        padding: 10px 14px;
        border: 1px solid alpha(@foreground, 0.10);
        border-radius: 12px;
        background-color: alpha(@foreground, 0.06);
        color: @foreground;
        caret-color: @color4;
      }

      #input:focus {
        border-color: alpha(@color4, 0.85);
      }

      #scroll {
        margin: 0 6px 6px 6px;
      }

      #inner-box {
        background-color: transparent;
      }

      #entry {
        padding: 10px 12px;
        margin: 2px 4px;
        border-radius: 10px;
        background-color: transparent;
        color: alpha(@foreground, 0.9);
      }

      #entry:selected {
        background-color: alpha(@color4, 0.85);
        color: @background;
      }

      #entry:selected #text {
        color: @background;
      }

      #img {
        margin-right: 10px;
      }
    '';
  };

  # Seed a colorscheme for waybar so the stylesheet always resolves its
  # @import. `wallpaperPicker` overwrites this file via pywal later.
  home.activation.waybarColors = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    colorsFile="$HOME/.config/waybar/colors.css"
    if [ ! -e "$colorsFile" ]; then
      mkdir -p "$HOME/.config/waybar"
      cat > "$colorsFile" <<'EOF'
    @define-color background #0e1420;
    @define-color foreground #e6edf3;
    @define-color cursor #e6edf3;
    @define-color color0 #0e1420;
    @define-color color1 #ff6b6b;
    @define-color color2 #5dd39e;
    @define-color color3 #f4d35e;
    @define-color color4 #589df6;
    @define-color color5 #b48ead;
    @define-color color6 #88c0d0;
    @define-color color7 #e6edf3;
    EOF
    fi
  '';

  # Make sure the wallpaper folder exists for the picker.
  home.file."Pictures/Wallpapers/.keep".text = "";

  # Home Manager's sway module only wires up the "reload on rebuild" hook when
  # it manages the sway package. We use the system sway (`package = null`), so
  # rebuilds would otherwise never reload the running compositor. Do it here.
  xdg.configFile."sway/config".onChange = lib.mkForce ''
    for sock in "''${XDG_RUNTIME_DIR:-/run/user/$UID}"/sway-ipc.*.sock; do
      if [ -S "$sock" ]; then
        ${pkgs.sway-unwrapped}/bin/swaymsg -s "$sock" reload || true
      fi
    done
  '';

  programs.kitty = lib.mkForce {
    enable = true;
    settings = {
      # Themes (use kitten themes),
      # unless u find where it stores kitten themes and u can xdg.config source it

      font_family = "FantasqueSansM Nerd Font Mono";
      font_size = 16;

      confirm_os_window_close = 0;
      enable_audio_bell = false;
      mouse_hide_wait = "-1.0";

      window_padding_width = 10;
      dynamic_background_opacity = true;
      background_opacity = "0.7";
      background_blur = 25;

    };
  };
}
