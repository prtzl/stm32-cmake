# STM32 CMake project template

This repository is not maintained anymore and is here for youtube viewers. New version of this repository is available [here](https://github.com/prtzl/stm32).

## Dependencies

```shell
git
gnumake
cmake
gcc-arm-embedded
clang-tools (optional)
```

I would recommend gcc-10.3.y for latest C++20 features. Versions 9.x.y will still do C++20 but with a limited feature set. If you have newer, then go for it.  

You can download arm-none-eabi toolchain from [website](https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm/downloads). It is universal for most distros. If your distribution carries it, install it with that, but mind the version and compatability.  

Fedora 35 comes with latest gcc-11 with these packages:

```shell
arm-none-eabi-gcc-cs
arm-none-eabi-gcc-cs-c++
arm-none-eabi-newlib
```

Fedora does not have gdb in its packages, so you might want to download that separately.  

On ubuntu 20.04 LTS you can install all with just one package, but comes with older gcc-9, which does not support all the C++20 features:

```shell
gcc-arm-none-eabi
```

Arch has gcc-11 and you can install it with following packages:

```shell
arm-none-eabi-gcc
arm-none-eabi-newlib

optional:
arm-none-eabi-gdb (debugger)
arm-none-eabi-binutils (utilities)
```

**NOTE**. If your cmake fails to "compile a simple test program" while running the example, then you might not have `newlib` installed (one of the errors I have encountered). In the examples above, fedora and arch carry the package separately, but ubuntu has it all in one.

## Example
You can utilize everything in root of the repository to build an example project.

## Workflow

Output files will be located, by default, in `build`. You can change that with `BUILD_DIR` parameter in the [Makefile](Makefile).

Just run cmake:

```shell
make cmake
```

Run cmake and build:

```shell
make -j<number of threads>
```

Clean:

```shell
make clean
```

Format all source files:

```shell
make format -j<number of threads>
```
