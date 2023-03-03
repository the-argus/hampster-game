{
  nimPackages,
  nimRelease ? true,
  fetchFromGitHub,
  raylib,
  ...
}:
nimPackages.buildNimPackage rec {
  pname = "nimraylib_now";
  version = "v0.15.0";
  nimBinOnly = false;

  propagatedBuildInputs = [raylib];

  inherit nimRelease;
  nimFlags = [
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

  passthru = {
    inherit raylib;
  };
}
