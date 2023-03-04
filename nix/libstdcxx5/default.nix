{
  libstdcxx5,
  wrapped-musl-gcc,
  musl,
  lib,
  ...
}:
libstdcxx5.overrideAttrs (oa: {
  configureFlags = (lib.lists.remove "--enable-clocale=gnu" oa.configureFlags) ++ [
    "--build=x86_64-musl-linux"
  ];
  buildInputs = [wrapped-musl-gcc musl musl.dev];
})
