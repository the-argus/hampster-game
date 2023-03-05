{
  nimRelease ? true,
  nimPackages,
  xorg,
  nim_chipmunk,
  musl,
  nimraylib_now,
  isStatic ? false,
  hotcodereload ? false,
  upx,
  binutils,
  lib,
  libnim,
  ...
}: let
  nimFlags =
    [
      "--threads:on"
      "-d:release"
      "-d:nimraylib_now_shared"
    ]
    ++ (lib.lists.optionals hotcodereload [
      "--hotcodereloading:on"
      "--passL:-lnimhcr"
      "--passL:-lnimrtl"
    ])
    ++ (lib.lists.optionals isStatic [
      "--gcc.exe=\"musl-gcc\""
      "--gcc.linkerexe=\"musl-gcc\""
      "--passC:-static"
      "--passL:-static"
      "-d:nimraylib_now_linkingOverride"
      "--passL:${nimraylib_now.raylib}/lib/libraylib.a"
      "--passL:${nim_chipmunk.chipmunk}/lib/libchipmunk.a"
    ]);
in
  nimPackages.buildNimPackage rec {
    pname = "hampster_game";
    version = "0.0.1";
    src = ../../.;

    nimBinOnly = false;
    nimbleFile = ../../hampster_game.nimble;
    inherit nimRelease nimFlags;

    nativeBuildInputs = lib.lists.optionals isStatic [
      upx
      binutils
      musl
      musl.dev
    ];

    buildInputs = with nimPackages; [
      libnim
      xorg.libX11
      xorg.libXcursor
      xorg.libXrandr.dev
      xorg.libXinerama
      xorg.libXi
      nim_chipmunk
      nimraylib_now
    ];

    postFixup = lib.strings.optionalString isStatic ''
      strip -s $out/bin/${pname}
      upx --best $out/bin/${pname}
    '';
  }
