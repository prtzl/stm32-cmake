# STM32 CMake project template

## Dependencies

For native development on your computer install the following packages:

* git
* gnumake
* cmake
* gcc-arm-embedded
* clang-tools (optional)

I would recommend gcc-10.3.y for latest C++20 features. Versions 9.x.y will still do C++20 but with a limited feature set. If you have newer, then go for it.  

You can download arm-none-eabi toolchain from [website](https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm/downloads). It is universal for most distros. If your distribution carries it, install it with that, but mind the version and compatibility.  

**NOTE**. If your cmake fails to "compile a simple test program" while running the example, then you might not have `newlib` installed (one of the errors I have encountered). Some distribution packages carry the package separately.

### Container

For reproducible development environment use the provided [container](Dockerfile). It installs the latest gcc-arm-embedded toolchain from ARMs website.

You can use the same [Makefile](Makefile) to build container image and your project. Refer to [workflow](#workflow) for instructions.  
There is also a `docker-compose.yml`, which you can use without `make` installed. Refer to [workflow](#workflow) for instructions.  

Default container manager is [podman](https://podman.io/). You can also use the more popular [docker](https://www.docker.com/) as well, as the syntax is mostly the same. You can read on the differences between the two [here](https://phoenixnap.com/kb/podman-vs-docker).  

Tested with docker (`20.10.9`), podman (`3.4.3`), docker-compose (`1.29.2`) on Fedora 35.

### Nix shell

Provided [default.nix](default.nix) installs required dependencies. If you have installed `direnv` to your shell, call `direnv allow` to automatically load the shell. Otherwise, call `nix-shell`.  
Because nix package for gcc-arm-embedded uses ARMs website version, same as with the docker container, you can expect the same results. Refer to [workflow](#workflow) on using Makefile for native development.

## Example

You can utilize everything in root of the repository. It holds an example project built around `STM32F407VG`.

## Workflow

You have a choice of using provided [Makefile](Makefile) or `docker-compose`. The other is useful if you don't have any build tools installed at all. Both tools are compatible with each other, since Makefile default target is to build on host system, which can be you computer or container.  

### Using Makefile

All actions are executed with the provided [Makefile](Makefile). Targets that build and execute tools in container have a suffix `-container`. Others execute on host computer.  

To build on local machine run `make -j<threads>`.  
To build using container run `make build-container`.  

Following targets are available:

`make -j<threads>`: build project.  
`make cmake`: (re)run cmake.  
`make build -j<threads>`: same as `make`.  
`make clean`: remove build folder.  
`make build-container`: (re)build the container image, run container to build project using container.  
`make image`: (re)build the container image.  
`make container`: run the container.  
`make shell`: run container and connect to shell, exit with `Ctrl+D` or `exit` command.  
`make clean-image`: remove container and image.  
`make clean-all`: remove build folder, remove container, remove image.  

Run `<docker/podman> container prune` and enter `y` to remove any leftover containers.

### Using docker-compose

First build the image:

```shell
docker-compose build --build-arg UID=$(id -u) --build-arg GID=$(id -g) --build-arg USERNAME=$(id -un) --build-arg GROUPNAME=$(id -gn) container
```

There are several services for the `docker-compose`, which are analog to Makefile targets:  

`docker-compose run stmbuild`: build the project  
`docker-compose run stmrebuild`: rebuild the project  
`docker-compose run stmclean`: clean the project  
`docker-compose run shell`: connect to container shell  

Run `docker-compose down` after you're done to remove containers.  

**NOTE:** Syntax for `podman-compose` is similar to `docker-compose`, but as of now I'm having problems running the services the same way as with `docker-compose`.  

### Code style

Before committing code, format all source files by running:

`make format`: formats all source files in root using host computer.  
`make format-container`: formats all source files in root using container.  
