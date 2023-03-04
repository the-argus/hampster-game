{
  nimRelease ? true,
  nimPackages,
  fetchgit,
  chipmunk,
  ...
}: let
  nimblemeta = builtins.toFile "nimblemeta.json" ''
    {"url":"https://github.com/avahe-kellenberger/nim-chipmunk","files":["chipmunk.nim", "chipmunk7.nim", "src/chipmunk7.nim"],"binaries":[],"isLink":false}
  '';
  nimFlags = [
    "-d:release"
  ];
  src = fetchgit {
    url = "https://github.com/avahe-kellenberger/nim-chipmunk";
    sha256 = "0cqdh92wv5pzkirw1dv4r7i4aj8mc2b6f9jyi6l96g6dw1pjylh0";
    rev = "d88d08251f9bb68d6c889eb372628b90eb66d602";
  };
in
  (nimPackages.buildNimPackage {
    pname = "chipmunk7";
    version = "7.0.3";

    inherit nimRelease nimFlags src;

    nimBinOnly = false;
    nimbleFile = "${src}/chipmunk7.nimble";

    prePatch = ''
      sed -i "s/.*dynlib.*//g" src/chipmunk7.nim
      sed -i "s/{.pop.}//g" src/chipmunk7.nim 
    '';

    propagatedBuildInputs = [chipmunk];

    passthru = {inherit chipmunk;};
  })
  .overrideAttrs (_: {
    postFixup = ''
      echo "include src/chipmunk7" > $out/chipmunk.nim
      echo "include src/chipmunk7" > $out/chipmunk7.nim
      cp ${nimblemeta} $out/nimblemeta.json
    '';
  })
