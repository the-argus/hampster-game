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
          (_: super: let
            mkXorgStatic = super.callPackage ./nix/mk-xorg-static {};
            wrapped-musl-gcc = super.callPackage ./nix/wrapped-musl-gcc {};
            libstdcxx5 = super.callPackage ./nix/libstdcxx5 {inherit wrapped-musl-gcc;};
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
            libvdpau = super.callPackage ./nix/libvdpau {inherit libstdcxx5;};
            chipmunk = super.callPackage ./nix/chipmunk {};
            raylib = super.callPackage ./nix/raylib {};
          })
        ];
      });
  in {
    packages = genSystems (system: {
      hampster-game = pkgs.${system}.callPackage ./nix/default {
        inherit (self.packages.${system}) nimraylib_now nim_chipmunk;
      };
      default = self.packages.${system}.hampster-game;
      nim_chipmunk = pkgs.${system}.callPackage ./nix/nim_chipmunk {};
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
