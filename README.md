# STM32 CMake project template

## Dependencies

For native development on your computer install the following packages:

* git
* gnumake
* cmake
* gcc-arm-embedded
* clang-tools (optional)

I would recommend gcc-10.3.y for latest C++20 features. Versions 9.x.y will still do C++20 but with a limited feature set. If you have newer, then go for it.  

You can download arm-none-eabi toolchain from [website](https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm/downloads). It is universal for most distros. If your distribution carries it, install it with that, but mind the version and compatability.  

**NOTE**. If your cmake fails to "compile a simple test program" while running the `Example`, then you might not have `newlib` installed (one of the errors I have encountered). Some distribution packages carry the package separately.

### Container

For reproducable development environment use the provided [container](Dockerfile). It installs the latest gcc-arm-embedded toolchain from ARMs website. Use the same [Makefile](Makefile) to build container image and your project. Refer to [workflow](#workflow) for instructions.  

Default container manager is [podman](https://podman.io/). You can also use the more popular [docker](https://www.docker.com/) as well, as the syntax is mostly the same. You can read on the differences between the two [here](https://phoenixnap.com/kb/podman-vs-docker).  

*Tested with*: docker (`20.10.9`), podman (`3.4.3`)

### Nix shell

Provided [default.nix](default.nix) installs required dependencies. If you have installed `direnv` to your shell, call `direnv allow` to automaticaly load the shell. Otherwise, call `nix-shell`.  
Because nix package for gcc-arm-embedded uses ARMs website version, same as with the docker container, you can expect the same results.

## Example

You can utilize everything in root of the repository. [Example](Example) folder has links to [Makefile](Makefile) and [gcc-arm-non-eabi.cmake](gcc-arm-none-eabi.cmake), but its own [CMakeLists.txt](Example/CMakeLists.txt)`. Since Unix links don't work on windows, delete them and copy over the original files.

## Workflow

All actions are executed with the provided [Makefile](Makefile). Targets that build and execute tools in container have a suffix `-container`. Others execute on host computer.  

To build on local machine run `make  -j<threads>`.  
To build using container run `make build-container`.  

Following targets are available:

`make -j<threads>`: build project.  
`make cmake`: (re)run cmake.  
`make build -j<threads>`: same as `make`.  
`make clean`: remove build folder.  
`make build-container`: (re)build the container image, run container, build project using container.  
`make image`: (re)build the container image.  
`make container`: run the container.  
`make stop`: stop and remove the running container.  
`make shell`: connect to container shell, exit with `Ctrl+D` or `exit` command.  
`make clean-image`: remove container and image.  
`make clean-all`: remove build folder, stop and remove running container, remove image.  

### Code style

Before committing code, format all source files by running:

`make format`: formats all source files in root using host computer.  
`make format-container`: formats all source files in root using container.  
