{
  nimRelease ? true,
  nimPackages,
  xorg,
  raylib,
  nim_chipmunk,
  musl,
  nimraylib_now,
  ...
}: let
  nimFlags = [
    "--threads:on"
    "-d:release"
    "-d:nimraylib_now_wayland"
    "--passL:${xorg.libX11}/lib/libX11.so"
    "--passC:-I${xorg.libX11}/include"
  ];
in
  nimPackages.buildNimPackage {
    pname = "hampster_game";
    version = "0.0.1";
    src = ../../.;
    CC = "${musl}/bin/musl-gcc -static";

    nimBinOnly = false;
    nimbleFile = ../../hampster_game.nimble;
    inherit nimRelease nimFlags;

    buildInputs = with nimPackages; [
      raylib
      xorg.libX11
      xorg.libXcursor
      xorg.libXrandr.dev
      xorg.libXinerama
      xorg.libXi
      nim_chipmunk
      nimraylib_now
    ];
  }
