{
  original-raylib,
  musl,
  ...
}:
(original-raylib.overrideAttrs (oa: {
  buildInputs = oa.buildInputs ++ [musl];
  nativeBuildInputs = oa.nativeBuildInputs ++ [musl musl.dev];
  cmakeFlags = [
    "-DUSE_WAYLAND_DISPLAY=ON"
    # "-DUSE_EXTERNAL_GLFW=ON"
    "-DBUILD_EXAMPLES=OFF"
    "-DCUSTOMIZE_BUILD=1"
    "-DINCLUDE_EVERYTHING=ON"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DBUILD_SHARED_LIBS=OFF"
    "-DCC=musl-gcc"
  ];
  CC = "musl-gcc";
  preFixup = "";
}))
.override {sharedLib = false;}
