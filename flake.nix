{
  description = "hampster...";
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs?ref=nixos-22.11;
  };

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    supportedSystems = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mkXorgStatic = super: parentPkg:
      parentPkg.overrideAttrs (oa: {
        CC = "musl-gcc";
        CXX = "musl-gcc";
        CFLAGS = "-static";
        buildInputs = oa.buildInputs ++ [super.musl];
        nativeBuildInputs = oa.nativeBuildInputs ++ [super.musl super.musl.dev];
        configurePhase = "./configure --build=x86_64-musl-linux --prefix=$out";
      });
    genSystems = nixpkgs.lib.genAttrs supportedSystems;
    pkgs = genSystems (system:
      import nixpkgs {
        inherit system;
        overlays = [
          (_: super: let
            wrapped-musl-gcc = super.stdenv.mkDerivation {
              name = "wrapped-musl-gcc";
              src = super.musl;
              dontUnpack = true;
              buildInputs = [super.buildPackages.makeWrapper];
              installPhase = ''
                mkdir -p $out/bin
                ln -sf $src/bin/musl-gcc $out/bin/gcc
              '';
            };
            libstdcxx5 = super.libstdcxx5.overrideAttrs (oa: {
              configureFlags = super.lib.lists.remove "--enable-clocale=gnu" oa.configureFlags;
              buildInputs = [wrapped-musl-gcc super.musl super.musl.dev];
            });
          in {
            xorg =
              super.xorg
              // {
                libX11 = mkXorgStatic super super.xorg.libX11;
                libXcursor = mkXorgStatic super super.xorg.libXcursor;
                libXrandr = mkXorgStatic super super.xorg.libXrandr;
                libXinerama = mkXorgStatic super super.xorg.libXinerama;
                libXi = mkXorgStatic super super.xorg.libXi;
              };
            libvdpau = super.libvdpau.overrideAttrs (oa: {
              buildInputs = oa.buildInputs ++ [libstdcxx5 super.musl super.musl.dev];
              CC = "musl-gcc";
              # CXX = "musl-gcc";
              CFLAGS = "-static";
            });
            chipmunk = super.chipmunk.overrideAttrs (oa: {
              buildInputs = oa.buildInputs ++ [super.musl];
              nativeBuildInputs = oa.nativeBuildInputs ++ [super.musl super.musl.dev];
              cmakeFlags = [
                "-DINSTALL_STATIC=1"
                "-DCC=musl-gcc"
                "-DCXX=musl-gcc"
                "-DBUILD_SHARED=0"
              ];
              CC = "musl-gcc";
              CXX = "musl-gcc";
            });
            raylib = (super.raylib.overrideAttrs (oa: {
              buildInputs = oa.buildInputs ++ [super.musl];
              nativeBuildInputs = oa.nativeBuildInputs ++ [super.musl super.musl.dev];
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
            .override {sharedLib = false;};
          })
        ];
      });
  in {
    packages = genSystems (system: {
      hampster-game = pkgs.${system}.callPackage ./nix/default {
        inherit (self.packages.${system}) nimraylib_now nim_chipmunk;
      };
      default = self.packages.${system}.hampster-game;
      nim_chipmunk = pkgs.${system}.callPackage ./nix/chipmunk {};
      nimraylib_now = pkgs.${system}.callPackage ./nix/nimraylib_now {};
      raylib = pkgs.${system}.raylib;
      chipmunk = pkgs.${system}.chipmunk;
      libvdpau = pkgs.${system}.libvdpau;
    });

    devShell = genSystems (system:
      pkgs.${system}.mkShell {
        packages = with pkgs.${system}; [
          self.packages.${system}.chipmunk
          nim
          raylib
          xorg.libX11
          xorg.libXcursor
          xorg.libXrandr.dev
          xorg.libXinerama
          xorg.libXi
        ];
      });
  };
}
