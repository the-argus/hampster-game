{musl, ...}: parentPkg:
parentPkg.overrideAttrs (oa: {
  CC = "musl-gcc";
  CXX = "musl-gcc";
  CFLAGS = "-static";
  buildInputs = oa.buildInputs ++ [musl];
  nativeBuildInputs = oa.nativeBuildInputs ++ [musl musl.dev];
  configurePhase = "./configure --build=x86_64-musl-linux --prefix=$out";
})
