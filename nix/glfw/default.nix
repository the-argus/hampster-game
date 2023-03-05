{
  original-glfw,
  # musl,
  libxcb,
  ...
}:
original-glfw.overrideAttrs (oa: {
  # buildInputs = oa.buildInputs ++ [musl musl.dev libxcb];
  nativeBuildInputs = [libxcb] ++ oa.nativeBuildInputs;
  cmakeFlags =
    oa.cmakeFlags
    ++ [
	  "-DBUILD_SHARED_LIBS=OFF"
      "-DCMAKE_SHARED_LINKER_FLAGS=-lxcb"
    ];
})
