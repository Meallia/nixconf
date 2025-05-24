{...}: {
  config = {
    networking = {
      useDHCP = false;
      dhcpcd.enable = false;
    };
    time.timeZone = "Europe/Paris";
  };
}
