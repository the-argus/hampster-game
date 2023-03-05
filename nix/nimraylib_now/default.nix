{
  nimPackages,
  nimRelease ? true,
  fetchFromGitHub,
  raylib,
  libGL,
  ...
}:
nimPackages.buildNimPackage rec {
  pname = "nimraylib_now";
  version = "v0.15.0";
  nimBinOnly = false;

  propagatedBuildInputs = [raylib libGL];

  inherit nimRelease;
  nimFlags = [
    "-d:release"
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
