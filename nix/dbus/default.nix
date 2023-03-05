{
  musl,
  original-dbus,
  ...
}:
(original-dbus.overrideAttrs (oa: {
  buildInputs = [musl musl.dev] ++ oa.buildInputs;
  configureFlags =
    oa.configureFlags
    ++ [
      "--build=x86_64-musl-linux"
      "--enable-shared=no"
      "--enable-static=yes"
    ];
  CC = "musl-gcc";
  CXX = "musl-gcc";
  CFLAGS = "-static";
  CXXFLAGS = "-static";
  doCheck = false;
}))
.override {enableSystemd = false;}
