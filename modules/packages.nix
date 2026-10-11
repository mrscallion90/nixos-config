{ pkgs, ... }:
{
  # Root packages
  environment.systemPackages = with pkgs; [
    # Virtual Mic with Noise Supression Audio
    rnnoise-plugin # Used in modules/audio.nix
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
