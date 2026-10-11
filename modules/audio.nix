{ pkgs, ... }:
{
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

    # Processed microphone: rnnoise -> optional high-pass -> compressor -> limiter.
    # The raw ALSA microphone stays available as its own source.
    extraConfig.pipewire."99-mic-chain" = {
      "context.modules" = [
        {
          name = "libpipewire-module-filter-chain";

          args = {
            "node.description" = "Microphone (Processed)";
            "media.name" = "Microphone (Processed)";

            "filter.graph" = {
              nodes = [
                # 1. Noise suppression (preserves speech, removes background noise)
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

                # 2. Optional high-pass to remove low-frequency rumble (one node per channel)
                {
                  type = "ladspa";
                  name = "highpass_l";
                  plugin = "${pkgs.ladspaPlugins}/lib/ladspa/highpass_iir_1890.so";
                  label = "highpass_iir";

                  control = {
                    "Cutoff Frequency" = 80;
                    "Stages(2 poles per stage)" = 1;
                  };
                }
                {
                  type = "ladspa";
                  name = "highpass_r";
                  plugin = "${pkgs.ladspaPlugins}/lib/ladspa/highpass_iir_1890.so";
                  label = "highpass_iir";

                  control = {
                    "Cutoff Frequency" = 80;
                    "Stages(2 poles per stage)" = 1;
                  };
                }

                # 3. Compressor to even out voice volume
                {
                  type = "ladspa";
                  name = "compressor";
                  plugin = "${pkgs.ladspaPlugins}/lib/ladspa/sc4_1882.so";
                  label = "sc4";

                  control = {
                    "RMS/peak" = 0;
                    "Attack time (ms)" = 20;
                    "Release time (ms)" = 250;
                    "Threshold level (dB)" = -18;
                    "Ratio (1:n)" = 3;
                    "Knee radius (dB)" = 6;
                    "Makeup gain (dB)" = 0;
                  };
                }

                # 4. Limiter to stop peaks from clipping
                {
                  type = "ladspa";
                  name = "limiter";
                  plugin = "${pkgs.ladspaPlugins}/lib/ladspa/fast_lookahead_limiter_1913.so";
                  label = "fastLookaheadLimiter";

                  control = {
                    "Input gain (dB)" = 0;
                    "Limit (dB)" = -1;
                    "Release time (s)" = 0.1;
                  };
                }
              ];

              links = [
                { output = "rnnoise:Output (L)"; input = "highpass_l:Input"; }
                { output = "rnnoise:Output (R)"; input = "highpass_r:Input"; }
                { output = "highpass_l:Output"; input = "compressor:Left input"; }
                { output = "highpass_r:Output"; input = "compressor:Right input"; }
                { output = "compressor:Left output"; input = "limiter:Input 1"; }
                { output = "compressor:Right output"; input = "limiter:Input 2"; }
              ];

              inputs = [ "rnnoise:Input (L)" "rnnoise:Input (R)" ];
              outputs = [ "limiter:Output 1" "limiter:Output 2" ];
            };

            "capture.props" = {
              "audio.channels" = "2";
              "audio.position" = "[ FL FR ]";
              "channelmix.upmix" = true;
              "channelmix.normalize" = false;
              "node.name" = "capture.mic_processed";
              "node.passive" = true;
              "audio.rate" = 48000;
            };

            "playback.props" = {
              "audio.channels" = "2";
              "audio.position" = "[ FL FR ]";
              "node.name" = "mic_processed";
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
