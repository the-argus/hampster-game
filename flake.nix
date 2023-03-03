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
    genSystems = nixpkgs.lib.genAttrs supportedSystems;
    pkgs = genSystems (system:
      import nixpkgs {
        inherit system;
        overlays = [
          (_: super: {
            xorg =
              super.xorg
              // {
                libX11 = super.xorg.libX11.overrideAttrs (oa: {
                  CC = "musl-gcc -static";
                  CXX = "musl-gcc -static";
                  buildInputs = oa.buildInputs ++ [super.musl];
                  nativeBuildInputs = oa.nativeBuildInputs ++ [super.musl super.musl.dev];
                });
              };
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
            raylib =
              (super.raylib.overrideAttrs (oa: {
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
