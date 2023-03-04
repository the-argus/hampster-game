{
  original-libvdpau,
  libstdcxx5,
  musl,
  ...
}:
original-libvdpau.overrideAttrs (oa: {
  buildInputs = oa.buildInputs ++ [libstdcxx5 musl musl.dev];
  CC = "musl-gcc";
  # CXX = "musl-gcc";
  CFLAGS = "-static";
})
