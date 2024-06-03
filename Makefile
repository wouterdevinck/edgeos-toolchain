all: build-rpi4 build-pc

.PHONY: version
version:
	./build.sh version

.PHONY: prepare
prepare:
	./build.sh prepare

.PHONY: menuconfig-rpi4
menuconfig-rpi4:
	./build.sh menuconfig rpi4

.PHONY: menuconfig-pc
menuconfig-pc:
	./build.sh menuconfig pc

.PHONY: build-rpi4
build-rpi4:
	./build.sh build rpi4

.PHONY: build-pc
build-pc:
	./build.sh build pc

.PHONY: clean
clean:
	./build.sh clean