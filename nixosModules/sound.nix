{pkgs, ...}: {
  services.pulseaudio.enable = false;
  hardware.alsa.enablePersistence = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    extraConfig = {
      pipewire-pulse = {
        "50-combine-sink.conf" = {
          pulse.cmd = [
            {
              cmd = "load-module";
              args = "module-combine-sink";
            }
          ];
        };
      };
    };
  };
}
