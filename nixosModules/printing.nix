{pkgs, ...}: {
  services.printing.enable = true;
  services.printing.drivers = [
    (pkgs.callPackage ./../packages/printers/dcp365cn.nix {})
  ];
  hardware.printers = {
    ensurePrinters = [
      {
        name = "DCP365CN";
        location = "Home";
        deviceUri = "dnssd://Brother%20DCP-365CN._pdl-datastream._tcp.local/";
        model = "brother_dcp365cn_printer_en.ppd";
      }
    ];
    ensureDefaultPrinter = "DCP365CN";
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
