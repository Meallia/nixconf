{lib, ...}: {
  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 2048;
      cores = 4;
      graphics = true;
    };
    services.getty.autologinUser = "root";

    networking.interfaces = lib.mkForce {};
    networking.defaultGateway = lib.mkForce null;
    networking.useDHCP = lib.mkForce true;
  };
}
