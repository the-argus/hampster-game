{
  stdenv,
  fetchurl,
  nim,
  ...
}:
stdenv.mkDerivation rec {
  pname = "libnim";
  version = "1.6.10";

  src = fetchurl {
    url = "https://nim-lang.org/download/nim-${version}.tar.xz";
    hash = "sha256-E9dwL4tXCHur6M0FHBO8VqMXFBi6hntJxrvQmynST+o=";
  };

  buildInputs = [nim];

  buildPhase = ''
    cd lib
    mkdir DUMMYHOME
    HOME=./DUMMYHOME nim c --app:lib --threads:on --define:createNimRtl nimrtl.nim
    HOME=./DUMMYHOME nim c --app:lib --threads:on -d:useNimRtl -d:createNimHcr nimhcr.nim
    cd -
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp lib/libnimhcr.so $out/lib
    cp lib/libnimrtl.so $out/lib
  '';
}
