{
  libstdcxx5,
  wrapped-musl-gcc,
  musl,
  ...
}:
libstdcxx5.overrideAttrs (oa: {
  configureFlags = super.lib.lists.remove "--enable-clocale=gnu" oa.configureFlags;
  buildInputs = [wrapped-musl-gcc musl musl.dev];
})
