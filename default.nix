with (import <nixpkgs> {});

stdenv.mkDerivation {
  name = "STM32";

  nativeBuildInputs = with pkgs; [
    clang-tools
    cmake
    gcc-arm-embedded
    git
    gnumake
  ];
}
