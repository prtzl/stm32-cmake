.PHONY: all build build-container cmake format format-container shell image container stop clean clean-image clean-all

UID ?= $(shell id -u)
GID ?= $(shell id -g)
USER ?= $(shell id -un)
GROUP ?= $(shell id -gn)
WORKDIR := ${PWD}

CONTAINER_TOOL ?= docker
CONTAINER_FILE := Dockerfile
IMAGE_NAME := fedora-arm-embedded-dev
CONTAINER_NAME := fedora-arm-embedded-dev

NEED_IMAGE = $(shell $(CONTAINER_TOOL) image inspect ${IMAGE_NAME} 2> /dev/null > /dev/null || echo image)
NEED_CONTAINER = $(shell $(CONTAINER_TOOL) container inspect ${CONTAINER_NAME} 2> /dev/null > /dev/null || echo container)
PODMAN_ARG = $(shell if [ "$(CONTAINER_TOOL)" = "podman" ];then echo "--userns=keep-id"; else echo ""; fi)

BUILD_DIR ?= build
BUILD_TYPE ?= Debug

all: build

build: cmake
	$(MAKE) -C ${BUILD_DIR} --no-print-directory

cmake: ${BUILD_DIR}/Makefile

${BUILD_DIR}/Makefile:
	cmake \
		-B${BUILD_DIR} \
		-DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
		-DCMAKE_TOOLCHAIN_FILE=gcc-arm-none-eabi.cmake \
		-DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
		-DDUMP_ASM=OFF

SRCS := $(shell find . -name '*.[ch]' -or -name '*.[ch]pp')
format: $(addsuffix .format,${SRCS})
%.format: %
	clang-format -i $<

build-container: ${NEED_CONTAINER}
	$(CONTAINER_TOOL) exec -it ${CONTAINER_NAME} bash -lc 'make build -j$(shell nproc)'

format-container: ${NEED_CONTAINER}
	$(CONTAINER_TOOL) exec -it ${CONTAINER_NAME} bash -lc 'make format -j$(shell nproc)'

shell: ${NEED_CONTAINER}
	$(CONTAINER_TOOL) exec -it ${CONTAINER_NAME} bash -l

image: ${CONTAINER_FILE}
	$(CONTAINER_TOOL) build \
		-t ${IMAGE_NAME} \
		-f=${CONTAINER_FILE} \
		--build-arg UID=$(UID) \
		--build-arg GID=$(GID) \
		--build-arg USERNAME=$(USER) \
		--build-arg GROUPNAME=$(GROUP) \
		.

container: ${NEED_IMAGE}
	$(CONTAINER_TOOL) run \
		--name ${CONTAINER_NAME} \
		--rm \
		--detach \
		$(PODMAN_ARG) \
		-v ${HOME}:${HOME} \
		--workdir ${WORKDIR} \
		--security-opt label=disable \
		--hostname ${CONTAINER_NAME} \
		${IMAGE_NAME} \
		sleep infinity

stop:
	$(CONTAINER_TOOL) stop -t 1 ${CONTAINER_NAME} 2> /dev/null > /dev/null || true
	$(CONTAINER_TOOL) container rm -f ${CONTAINER_NAME} 2> /dev/null > /dev/null || true

clean:
	rm -rf ${BUILD_DIR}

clean-image: stop
	$(CONTAINER_TOOL) image rmi -f ${IMAGE_NAME} 2> /dev/null > /dev/null || true

clean-all: clean clean-image
