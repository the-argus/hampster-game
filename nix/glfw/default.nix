{
  original-glfw,
  musl,
  libxcb,
  ...
}:
original-glfw.overrideAttrs (oa: {
  buildInputs = oa.buildInputs ++ [musl musl.dev libxcb];
  nativeBuildInputs = [libxcb] ++ oa.nativeBuildInputs;
  CC = "musl-gcc -static";
  CXX = "musl-gcc -static";
})
