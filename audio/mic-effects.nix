# Microphone effect chain for PipeWire's libpipewire-module-filter-chain.
#
# Returns the module `args` for a virtual "Microphone Effects" source.
# The graph is mono; PipeWire duplicates it per channel to match the
# capture/playback streams (which stay stereo).
#
# This file is pure (no NixOS module), so it can be evaluated stand-alone:
#   nix-instantiate --eval --json -E \
#     '(import ./mic-effects.nix { pkgs = import <nixpkgs> {}; lib = (import <nixpkgs> {}).lib; })'
{ pkgs, lib }:

let
  # ---------------------------------------------------------------------------
  # Tunables. Every stage can be disabled with `enable = false`; the remaining
  # stages are automatically re-linked in order.
  # ---------------------------------------------------------------------------
  cfg = {
    # 1. Input gain (attenuation). Negative dB = quieter.
    inputGainDb = -10.0;

    # 2. High-pass filter: removes low-frequency rumble / handling noise.
    highpass = {
      enable = true;
      freq = 90.0;
      q = 0.707;
    };

    # 3. Noise gate with hysteresis (separate open/close thresholds) plus
    #    attack/hold/release so speech does not get chopped.
    gate = {
      enable = true;
      openThresholdDb = -45.0;
      hysteresisDb = 3.0;
      attackSec = 0.005;
      holdSec = 0.150;
      releaseSec = 0.100;
    };

    # 4. Noise suppression: existing LADSPA rnnoise denoiser (mono instance).
    denoise = {
      enable = true;
      vadThreshold = 50.0;
      gracePeriodMs = 200.0;
      retroGraceMs = 0.0;
    };

    # 5. Compressor: evens out speech level (threshold ~ -18 dBFS, 3:1).
    compressor = {
      enable = true;
      thresholdDb = -18.0;
      ratio = 3.0;
      attackMs = 20.0;
      releaseMs = 250.0;
      kneeDb = 3.0;
      makeupDb = 0.0;
    };

    # 6. Limiter: brick-wall peak ceiling (safety net against clipping).
    limiter = {
      enable = true;
      ceilingDb = -3.0;
    };
  };

  # Nix has no pow()/exp() builtins, so compute 10^(db/20) with a Taylor
  # series. Only used at evaluation time for the control values below.
  ln10 = 2.302585092994046;
  exp = x:
    let
      go = i: term: acc:
        if i > 60 then acc
        else
          let
            term' = term * x / i;
          in
          go (i + 1) term' (acc + term');
    in
    go 1 1.0 1.0;
  dbToLinear = db: exp (db * ln10 / 20.0);

  # Each stage is one filter-graph node; inPort/outPort name its audio ports.
  stages = lib.filter (s: s != null) [
    {
      name = "input_gain";
      inPort = "In";
      outPort = "Out";
      node = {
        type = "builtin";
        name = "input_gain";
        label = "linear";
        control = {
          "Mult" = dbToLinear cfg.inputGainDb;
          "Add" = 0.0;
        };
      };
    }

    (if cfg.highpass.enable then {
      name = "highpass";
      inPort = "In";
      outPort = "Out";
      node = {
        type = "builtin";
        name = "highpass";
        label = "bq_highpass";
        control = {
          "Freq" = cfg.highpass.freq;
          "Q" = cfg.highpass.q;
          "Gain" = 0.0;
        };
      };
    } else null)

    (if cfg.gate.enable then {
      name = "noise_gate";
      inPort = "In";
      outPort = "Out";
      node = {
        type = "builtin";
        name = "noise_gate";
        label = "noisegate";
        control = {
          "Open Threshold" = dbToLinear cfg.gate.openThresholdDb;
          "Close Threshold" = dbToLinear (cfg.gate.openThresholdDb - cfg.gate.hysteresisDb);
          "Attack (s)" = cfg.gate.attackSec;
          "Hold (s)" = cfg.gate.holdSec;
          "Release (s)" = cfg.gate.releaseSec;
        };
      };
    } else null)

    (if cfg.denoise.enable then {
      name = "denoise";
      inPort = "Input";
      outPort = "Output";
      node = {
        type = "ladspa";
        name = "denoise";
        plugin = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
        label = "noise_suppressor_mono";
        control = {
          "VAD Threshold (%)" = cfg.denoise.vadThreshold;
          "VAD Grace Period (ms)" = cfg.denoise.gracePeriodMs;
          "Retroactive VAD Grace (ms)" = cfg.denoise.retroGraceMs;
        };
      };
    } else null)

    (if cfg.compressor.enable then {
      name = "compressor";
      inPort = "Input";
      outPort = "Output";
      node = {
        type = "ladspa";
        name = "compressor";
        plugin = "${pkgs.ladspaPlugins}/lib/ladspa/sc1_1425.so";
        label = "sc1";
        control = {
          "Attack time (ms)" = cfg.compressor.attackMs;
          "Release time (ms)" = cfg.compressor.releaseMs;
          "Threshold level (dB)" = cfg.compressor.thresholdDb;
          "Ratio (1:n)" = cfg.compressor.ratio;
          "Knee radius (dB)" = cfg.compressor.kneeDb;
          "Makeup gain (dB)" = cfg.compressor.makeupDb;
        };
      };
    } else null)

    (if cfg.limiter.enable then {
      name = "limiter";
      inPort = "In";
      outPort = "Out";
      node = {
        type = "builtin";
        name = "limiter";
        label = "clamp";
        control = {
          "Min" = -dbToLinear cfg.limiter.ceilingDb;
          "Max" = dbToLinear cfg.limiter.ceilingDb;
        };
      };
    } else null)
  ];

  links = lib.zipListsWith
    (a: b: { output = "${a.name}:${a.outPort}"; input = "${b.name}:${b.inPort}"; })
    stages
    (builtins.tail stages);
in
{
  "node.description" = "Microphone Effects";
  "media.name" = "Microphone Effects";

  "filter.graph" = {
    nodes = map (s: s.node) stages;
    inherit links;
  };

  "capture.props" = {
    "node.name" = "capture.mic_effects";
    "node.passive" = true;
    "audio.channels" = 2;
    "audio.position" = "[ FL FR ]";
    "audio.rate" = 48000;
  };

  "playback.props" = {
    "node.name" = "mic_effects_source";
    "node.description" = "Microphone Effects";
    "media.class" = "Audio/Source";
    "audio.channels" = 2;
    "audio.position" = "[ FL FR ]";
    "audio.rate" = 48000;
    # Keep the virtual source as WirePlumber's default.
    "priority.session" = 2000;
  };
}
