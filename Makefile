all: build

.PHONY: version
version:
	./build.sh version

.PHONY: prepare
prepare:
	./build.sh prepare

.PHONY: menuconfig
menuconfig:
	./build.sh menuconfig

.PHONY: build
build:
	./build.sh build

.PHONY: clean
clean:
	./build.sh clean