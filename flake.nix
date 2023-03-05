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
    pkgs = genSystems (system: import nixpkgs {inherit system;});
  in {
    packages = genSystems (system: {
      hampster-game = pkgs.${system}.callPackage ./nix/default {
        inherit (self.packages.${system}) nim_chipmunk nimraylib_now;
      };
      default = self.packages.${system}.hampster-game;
      nim_chipmunk = pkgs.${system}.callPackage ./nix/nim_chipmunk {};
      nimraylib_now = pkgs.${system}.callPackage ./nix/nimraylib_now {};
      libnimhcr = pkgs.${system}.callPackage ./nix/libnimhcr {};
    });

    devShell = genSystems (system:
      pkgs.${system}.mkShell {
        packages = with pkgs.${system}; [
		  self.packages.${system}.nim_chipmunk
		  self.packages.${system}.libnimhcr
          gdb
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
