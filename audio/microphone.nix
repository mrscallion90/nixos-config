# Virtual microphone with an effects chain (gain, high-pass, noise gate,
# rnnoise denoiser, compressor, limiter). Tunables live in ./mic-effects.nix.
#
# The original hardware source is left untouched; this only adds a new
# virtual Audio/Source that applications can select.
{ config, pkgs, lib, ... }:

let
  args = import ./mic-effects.nix { inherit pkgs lib; };
in
{
  services.pipewire.extraConfig.pipewire."99-mic-effects" = {
    "context.modules" = [
      {
        name = "libpipewire-module-filter-chain";
        flags = [ "nofail" ];
        inherit args;
      }
    ];
  };
}
