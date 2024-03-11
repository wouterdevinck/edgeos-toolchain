#!/bin/bash
set -e

BR_VERSION=2024.02

CONFIG_RPI4_TOOLCHAIN=edgeos_rpi4_toolchain_defconfig

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
WORKDIR="$SCRIPT_DIR/buildroot"
EXTDIR="$SCRIPT_DIR/external"
OUTDIR="$SCRIPT_DIR/output"

EDGEOS_TOOLCHAIN_VERSION=$(git describe --tags --dirty)

CONFPATH_RPI4_TOOLCHAIN="$EXTDIR/configs/$CONFIG_RPI4_TOOLCHAIN"

OUTDIR_RPI4_TOOLCHAIN="$OUTDIR/rpi4-toolchain"

menuconfig () {
  make O=$1 BR2_DEFCONFIG=$2 defconfig
  make O=$1 BR2_EXTERNAL=$EXTDIR menuconfig
  make O=$1 BR2_DEFCONFIG=$2 savedefconfig
}

build () {
  make O=$1 BR2_EXTERNAL=$EXTDIR $2
  GOWORK=off make O=$1 $3
}

case $1 in

"version")
  echo $EDGEOS_TOOLCHAIN_VERSION
  ;;

"prepare")

  # Create directory for Buildroot
  rm -rf $WORKDIR
  mkdir -p $WORKDIR

  # Download and unpack Buildroot
  wget "https://buildroot.org/downloads/buildroot-$BR_VERSION.tar.gz"
  tar -xzf buildroot-$BR_VERSION.tar.gz -C $WORKDIR --strip-components 1
  rm buildroot-$BR_VERSION.tar.gz

  ;;

"build"|"menuconfig")

  # Check if prepare has been run
  if [ ! -d "$WORKDIR" ]; then
    printf "\nPlease run prepare first.\n\n"
    exit 2
  fi
  cd $WORKDIR
  
  # If running under WSL, locally fix the path. Buildroot doesn't like spaces on the path.
  if [[ $(grep -i Microsoft /proc/version) ]]; then 
    PATH=$(echo $PATH | tr ':' '\n' | grep -v /mnt/ | tr '\n' ':' | head -c -1)
  fi
  
  ;;&

"menuconfig")
  menuconfig $OUTDIR_RPI4_TOOLCHAIN $CONFPATH_RPI4_TOOLCHAIN
  ;;

"build")
  build $OUTDIR_RPI4_TOOLCHAIN $CONFIG_RPI4_TOOLCHAIN sdk
  ;;

"clean")
  rm -rf $WORKDIR $OUTDIR
  ;;

*)
  echo "Unknown command"
  ;;

esac
