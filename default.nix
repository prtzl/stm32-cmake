with import <nixpkgs> {};

pkgs.stdenv.mkDerivation {
  pname = "STM32";
  version = "1";

  nativeBuildInputs = with pkgs; [
    clang-tools
    cmake
    gcc-arm-embedded
    git
    gnumake
  ];
}
