{
  libstdcxx5,
  wrapped-musl-gcc,
  musl,
  lib,
  ...
}:
libstdcxx5.overrideAttrs (oa: {
  configureFlags = lib.lists.remove "--enable-clocale=gnu" oa.configureFlags;
  buildInputs = [wrapped-musl-gcc musl musl.dev];
})
