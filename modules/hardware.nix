{
  hardware.cpu.amd.updateMicrocode = true;

  hardware.graphics = { # trying to see if this works ffmpeg-vaapi (if filmcraft detects it) HEVC/H.265
    enable = true;
    enable32Bit = true;
  };

  hardware.enableAllFirmware = true; # camera

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings = {
      General = {
        # Shows battery charge of connected devices on supported
        # Bluetooth adapters. Defaults to 'false'.
        Experimental = true;
        # When enabled other devices can connect faster to us, however
        # the tradeoff is increased power consumption. Defaults to
        # 'false'.
        FastConnectable = false;
      };
      Policy = {
        # Enable all controllers when they are found. This includes
        # adapters present on start as well as adapters that are plugged
        # in later on. Defaults to 'true'.
        AutoEnable = false;
      };
    };
  };
}
