{
  original-libglvnd,
  musl,
  wrapped-musl-gcc,
  ...
}:
original-libglvnd.overrideAttrs (oa: {
  buildInputs = oa.buildInputs ++ [musl musl.dev wrapped-musl-gcc];
  configureFlags = [
    "--disable-tls"
    "--host=x86_64-musl-linux"
  ];
})
