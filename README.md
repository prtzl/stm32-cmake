# STM32 CMake project template

You will need the following tools installed:

```shell
git
gnumake
cmake
gcc-arm-embedded
clang-tools (optional)
```

## Compile project

Use number of threads that you want to use

```shell
make -j<number of threads>
```

Binary is located in `build` folder.

## Clean project

```shell
make clean
```

## Just set up cmake

```shell
make cmake
```
