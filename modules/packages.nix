{ pkgs, ... }:
{
  # Root packages
  environment.systemPackages = with pkgs; [
    # Virtual Mic with Noise Suppression (used by audio/microphone.nix)
    rnnoise-plugin
    ladspaPlugins # sc1 compressor for the mic effect chain
    # Internet download
    wget links2
    # Debugging
    helix busybox toybox
    # Pretty for nix output log
    nix-output-monitor
    # Required by services
    # Service: Configure Microphone
    alsa-utils pulseaudio
  ];
}
