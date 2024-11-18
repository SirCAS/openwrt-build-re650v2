#
# GNU Makefile
#


SHELL := bash -e

OPENWRT_RELEASE := 23.05.5

OPENWRT_TARGET := ramips
OPENWRT_SUBTARGET := mt7621
OPENWRT_PROFILE := tplink_re650-v2

DOCKER_IMAGE := openwrt-custom-builder:$(OPENWRT_RELEASE)


.PHONY: all
all: build

.PHONY: build
build:
	sed 's/__CACHE_BUSTER__/$(shell date +%s)/g' Dockerfile \
	| podman build -t $(DOCKER_IMAGE) -f - \
	       --build-arg OPENWRT_TARGET=$(OPENWRT_TARGET) \
	       --build-arg OPENWRT_SUBTARGET=$(OPENWRT_SUBTARGET) \
	       --build-arg OPENWRT_PROFILE=$(OPENWRT_PROFILE) \
	       --build-arg OPENWRT_RELEASE=$(OPENWRT_RELEASE) \
	       .
	mkdir -p firmware
	podman run --rm --name openwrt-build $(DOCKER_IMAGE) tar -c -C "bin/targets/$(OPENWRT_TARGET)/$(OPENWRT_SUBTARGET)" . | tar x -C firmware

.PHONY: clean
clean:
	rm -rf firmware


# EOF - Makefile
