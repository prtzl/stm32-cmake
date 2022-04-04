{
    inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    outputs = { self, nixpkgs }:
        let
            system = "x86_64-linux";
            pkgs = nixpkgs.legacyPackages.${system};
            lib = nixpkgs.lib;
            stdenv = pkgs.stdenv;
        in {
            sample-f407vg = stdenv.mkDerivation rec {
                pname = "sample-f407vg";
                version = "0.0.1";
                src = ./.;
                nativeBuildInputs = [ pkgs.cmake pkgs.ninja pkgs.gcc-arm-embedded ];
                CMAKE_BUILD_SYSTEM = "Ninja";
                CMAKE_BUILD_DIR = "build";
                CMAKE_BUILD_TYPE = "Debug";
                dontUseCmakeConfigure = true;
                buildPhase = ''
                    cmake \
                        -G "${CMAKE_BUILD_SYSTEM}" \
                        -B${CMAKE_BUILD_DIR} \
                        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \
                        -DCMAKE_TOOLCHAIN_FILE=gcc-arm-none-eabi.cmake \
                        -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
                        -DDUMP_ASM=OFF
                    cmake --build ${CMAKE_BUILD_DIR}
                '';
                installPhase = ''
                    mkdir -p $out
                    cp ${CMAKE_BUILD_DIR}/*.bin ${CMAKE_BUILD_DIR}/*.elf ${CMAKE_BUILD_DIR}/compile_commands.json $out
                '';
            };
            defaultPackage.${system} = self.sample-f407vg;
            devShell.${system} = pkgs.mkShell {
                nativeBuildInputs = [ self.sample-f407vg.nativeBuildInputs pkgs.gnumake];
            };
        };
}
