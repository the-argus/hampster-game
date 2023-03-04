{
  original-chipmunk,
  musl,
  ...
}:
original-chipmunk.overrideAttrs (oa: {
  buildInputs = oa.buildInputs ++ [musl];
  nativeBuildInputs = oa.nativeBuildInputs ++ [musl musl.dev];
  cmakeFlags = [
    "-DINSTALL_STATIC=1"
    "-DCC=musl-gcc"
    "-DCXX=musl-gcc"
    "-DBUILD_SHARED=0"
  ];
  CC = "musl-gcc";
  CXX = "musl-gcc";
})
