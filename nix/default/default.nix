{
  nimRelease ? true,
  nimPackages,
  xorg,
  raylib,
  nim_chipmunk,
  fetchFromGitHub,
  musl,
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
      (nimPackages.buildNimPackage rec {
        pname = "nimraylib_now";
        version = "v0.15.0";
        nimBinOnly = false;

        CC = "${musl}/bin/musl-gcc -static";

        inherit nimRelease;
        nimFlags = [
          "--threads:on"
          "-d:release"
          "-d:nimraylib_now_wayland"
        ];
        src = fetchFromGitHub {
          repo = pname;
          rev = version;
          owner = "greenfork";
          sha256 = "sha256-qVBGyapfil+Lr8cYZGqKuRpPd8nK2LAUWYUK2Rqdg5k=";
          fetchSubmodules = true;
        };

        nimbleFile = "${src}/nimraylib_now.nimble";
      })
    ];
  }
