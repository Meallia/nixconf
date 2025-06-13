{
  pkgsi686Linux,
  lib,
  fetchurl,
  cups,
  dpkg,
  gnused,
  makeWrapper,
  ghostscript,
  file,
  a2ps,
  coreutils,
  gnugrep,
  which,
  gawk,
}: let
  model = "dcp365cn";
  version = "1.1.3";
  lprdeb = fetchurl {
    url = "https://download.brother.com/welcome/dlf005419/${model}lpr-${version}-1.i386.deb";
    sha256 = "sha256-C8b4PMDNDo457evMGKSekbzTtPYLVZr3zX6VqsPmG7A=";
  };
  cupsdeb = fetchurl {
    url = "https://download.brother.com/welcome/dlf005421/${model}cupswrapper-${version}-1.i386.deb";
    sha256 = "sha256-nW6ulg2WYJHjvWWs+VhmgUBLOLn5UHuvmXZDYmRwEQ0=";
  };
in
  pkgsi686Linux.stdenv.mkDerivation {
    pname = "cups-brother-${model}";
    inherit version;

    nativeBuildInputs = [
      dpkg
      makeWrapper
    ];
    buildInputs = [
      cups
      ghostscript
      a2ps
      gawk
    ];
    unpackPhase = ''
      mkdir -p $out
      dpkg-deb -x ${cupsdeb} $out
      dpkg-deb -x ${lprdeb} $out
    '';

    installPhase = ''
      substituteInPlace $out/opt/brother/Printers/${model}/lpd/filter${model} \
      --replace /opt "$out/opt"

      patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $out/opt/brother/Printers/${model}/lpd/br${model}filter

      mkdir -p $out/lib/cups/filter/
      ln -s $out/opt/brother/Printers/${model}/lpd/filter${model} $out/lib/cups/filter/brlpdwrapper${model}

      wrapProgram $out/opt/brother/Printers/${model}/lpd/filter${model} \
        --prefix PATH ":" ${
        lib.makeBinPath [
          gawk
          ghostscript
          a2ps
          file
          gnused
          gnugrep
          coreutils
          which
        ]
      }

        for f in $out/opt/brother/Printers/${model}/cupswrapper/cupswrapper${model}; do
        wrapProgram $f --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          ghostscript
          gnugrep
          gnused
        ]
      }
      done

      mkdir -p $out/share/cups/model
      ln -s $out/opt/brother/Printers/${model}/cupswrapper/brother_${model}_printer_en.ppd $out/share/cups/model/
    '';

    meta = with lib; {
      homepage = "http://www.brother.com/";
      description = "Brother DCP-365CN printer driver";
      sourceProvenance = with sourceTypes; [binaryNativeCode];
      license = licenses.unfree;
      platforms = [
        "x86_64-linux"
        "i686-linux"
      ];
      #      maintainers = with maintainers; [ marcovergueira ];
    };
  }
