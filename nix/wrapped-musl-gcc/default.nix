{
  stdenv,
  buildPackages,
  musl,
  ...
}:
stdenv.mkDerivation {
  name = "wrapped-musl-gcc";
  src = musl;
  dontUnpack = true;
  buildInputs = [buildPackages.makeWrapper];
  installPhase = ''
    mkdir -p $out/bin
    ln -sf $src/bin/musl-gcc $out/bin/gcc
  '';
}
