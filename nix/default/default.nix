{
  nimRelease ? true,
  nimPackages,
  xorg,
  nim_chipmunk,
  musl,
  nimraylib_now,
  upx,
  binutils,
  ...
}: let
  nimFlags = [
    "--gcc.exe=\"musl-gcc\""
    "--gcc.linkerexe=\"musl-gcc\""

    "--threads:on"
    "-d:release"
    "-d:nimraylib_now_wayland"
    # "--passL:${xorg.libX11}/lib/libX11.la"
    # "--passC:-I${xorg.libX11}/include"
    "--passC:-static"
    "--passL:-static"
    "-d:nimraylib_now_linkingOverride"
    "--passL:${nimraylib_now.raylib}/lib/libraylib.a"
  ];
in
  nimPackages.buildNimPackage rec {
    pname = "hampster_game";
    version = "0.0.1";
    src = ../../.;

    nimBinOnly = false;
    nimbleFile = ../../hampster_game.nimble;
    inherit nimRelease nimFlags;

    nativeBuildInputs = [
      upx
      binutils
      musl
      musl.dev
    ];

    buildInputs = with nimPackages; [
      xorg.libX11
      xorg.libXcursor
      xorg.libXrandr.dev
      xorg.libXinerama
      xorg.libXi
      nim_chipmunk
      nimraylib_now
    ];

    postFixup = ''
      strip -s $out/bin/${pname}
      upx --best $out/bin/${pname}
    '';
  }
