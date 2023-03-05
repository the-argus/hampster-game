{original-libglvnd, ...}:
original-libglvnd.overrideAttrs (oa: {
  configureFlags = [
    "--disable-tls"
    "--host=x86_64-musl-linux"
    "--enable-shared"
    "--enable-static"
  ];
  postConfigure = ''
    sed -i "s/build_libtool_libs=yes/build_libtool_libs=no/g" libtool
  '';
})
