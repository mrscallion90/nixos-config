{ config, pkgs, ... }:

{
  # Enable the KDE Plasma Desktop Environment.
  # services.displayManager.sddm.enable = true;
  services.displayManager.ly.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.flatpak.enable = true; # sober

  services.libinput = {
    enable = true;
    # Touchpad
    touchpad = {
      naturalScrolling = true; # Enables Natural scrolling
      accelProfile = "flat";   # Disables mouse acceleration
    };

    # Mouse
    mouse = {
      naturalScrolling = true; # Enables Natural scrolling
      accelProfile = "flat";   # Disables mouse acceleration
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Mullvad VPN
  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # Use the WirePlumber session manager
    #wireplumber.enable = true;
    extraConfig.pipewire."99-rnnoise" = {
      "context.modules" = [
        {
          name = "libpipewire-module-filter-chain";

          args = {
            "node.description" = "Noise Suppression";
            "media.name" = "Noise Suppression";

            "filter.graph" = {
              nodes = [
                {
                  type = "ladspa";
                  name = "rnnoise";
                  plugin = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
                  label = "noise_suppressor_stereo";

                  control = {
                    "VAD Threshold (%)" = 50;
                    "VAD Grace Period (ms)" = 200;
                    "Retroactive VAD Grace (ms)" = 0;
                  };
                }
              ];
            };

            "capture.props" = {
              "audio.channels" = "2";
              "audio.position" = "[ FL FR ]";
              "channelmix.upmix" = true;
              "channelmix.normalize" = false;
              "node.name" = "capture.rnnoise_source";
              "node.passive" = true;
              "audio.rate" = 48000;
            };

            "playback.props" = {
              "audio.channels" = "2";
              "audio.position" = "[ FL FR ]";
              "node.name" = "rnnoise_source";
              "media.class" = "Audio/Source";
              "audio.rate" = 48000;
            };
          };
        }
      ];
    };
  };

  # Root level
  systemd.services.noise-suppresion-mic = {
    # Cursed Ass Microphone in Linux
    description = "Configure Microphone: Internal Mic Boost set to 0";

    wantedBy = [ "sound.target" ];
    after = [ "sound.target" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "service-noise-suppression-mic"
      ''
      set -eu
      # This thing is 3 by default for some reason
      ${pkgs.alsa-utils}/bin/amixer -c 1 sset 'Internal Mic Boost' "0" 
      # Set volume Mic to 35% since I cant find why its so boosted so we just counter by lowering it
      # ${pkgs.pulseaudio}/bin/pactl set-source-volume "alsa_input.pci-0000_04_00.6.analog-stereo" "35%"
      '';
      RemainAfterExit = true;
    };
  };


  # User level
  systemd.user.services.configure-microphone-volume = {
    description = "Configure microphone volume to 35%";

    wantedBy = [ "default.target" ];
    after = [ "pipewire.service" "pipewire-pulse.service" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "configure-microphone-volume" ''
        #!/bin/sh
        set -eu

        PACTL=${pkgs.pulseaudio}/bin/pactl
        SOURCE="alsa_input.pci-0000_04_00.6.analog-stereo"

        for i in $(seq 1 20); do
          if "$PACTL" info >/dev/null 2>&1; then
            "$PACTL" set-source-volume "$SOURCE" 35%
            exit 0
          fi
          sleep 0.5
        done

        echo "PipeWire/PulseAudio is unavailable" >&2
        exit 1
      '';
      RemainAfterExit = true;
    };
  };
}
