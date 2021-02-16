#!/bin/sh
set -e

if [ "${KERNEL_SRC}x" = "x" ]; then
  echo "ERROR: KERNEL_SRC not set" >/dev/stderr
  exit 1
fi

if [ \( $# -eq 1 -a "$1" = "-h" \) -o $# -gt 1 ]; then
  echo "Usage: $0 [RPI_PLAT]"
  echo "where RPI_PLAT is one of:"
  echo "pi0, pi1, cm   for Pi 1/Zero/Zero W, CM (32-bit)"
  echo "pi2, pi3, cm3  for Pi 2/3/3+, CM 3 (32-bit)"
  echo "pi4            for Pi 4 (32-bit)"
  echo "pi3_64, cm3_64 for Pi 3/3+, CM 3 (64-bit)"
  echo "pi4_64         for Pi 4 (64-bit)\n"
  echo "If RPI_PLAT is not provided build target may be chosen from menu on run-time."
  exit 0
fi

if [ $# -le 0 ]; then
  echo "Building for:"
  echo "1) Pi 1/Zero/Zero W, CM (32-bit)"
  echo "2) Pi 2/3/3+, CM 3 (32-bit)"
  echo "3) Pi 4 (32-bit)"
  echo "4) Pi 3/3+, CM 3 (64-bit)"
  echo "5) Pi 4 (64-bit)"

  read -p ":" choice
else
  case $1 in
  pi[01]|cm)
    choice=1;;
  pi[23]|cm3)
    choice=2;;
  pi4)
    choice=3;;
  pi3_64|cm3_64)
    choice=4;;
  pi4_64)
    choice=5;;
  *)
    echo "ERROR: Invalid script argument passed" >/dev/stderr
    exit 1;;
  esac
fi

case ${choice} in
  1)
    export ARCH=arm
    export CROSS_COMPILE=${TOOLCHAIN32}
    target=bcmrpi_defconfig;;
  2)
    export ARCH=arm
    export CROSS_COMPILE=${TOOLCHAIN32}
    target=bcm2709_defconfig;;
  3)
    export ARCH=arm
    export CROSS_COMPILE=${TOOLCHAIN32}
    target=bcm2711_defconfig;;
  4)
    export ARCH=arm64
    export CROSS_COMPILE=${TOOLCHAIN64}
    target=bcmrpi3_defconfig;;
  5)
    export ARCH=arm64
    export CROSS_COMPILE=${TOOLCHAIN64}
    target=bcm2711_defconfig;;
  *)
    echo "ERROR: Invalid input" >/dev/stderr
    exit 1;;
esac

if [ "${CROSS_COMPILE}x" = "x" ]; then
  echo "ERROR: TOOLCHAIN not set for ${ARCH} build" >/dev/stderr
  exit 1
fi

build_cores=$(cat /proc/cpuinfo | awk '/cpu cores/{print $4; exit(0)}')

make -C ${KERNEL_SRC} ${target}
make -C ${KERNEL_SRC} -j${build_cores}

root_dir=.rpi_root
ker_rel=$(make -s -C ${KERNEL_SRC} kernelrelease)
ker_ver=$(make -s -C ${KERNEL_SRC} kernelversion)
arch_name=kernel-${ker_rel}.tar.gz

case $(echo ${ker_rel} | sed "s/${ker_ver}\(.*\)/\\1/") in
  +)
    img_name=kernel.img;;
  -v7+)
    img_name=kernel7.img;;
  -v7l+)
    img_name=kernel7l.img;;
  -v8+)
    img_name=kernel8.img
    if [ "${target}" = "bcm2711_defconfig" ]; then
      arch_name=kernel-${ker_ver}-v8l+.tar.gz
      fi;;
  *)
    echo "ERROR: Kernel release not recognized" >/dev/stderr
    exit 1;;
esac

mkdir ${root_dir}
mkdir ${root_dir}/boot
mkdir ${root_dir}/boot/overlays

INSTALL_MOD_PATH=$(pwd)/${root_dir} make -C ${KERNEL_SRC} modules_install
rm -f ${root_dir}/lib/modules/${ker_rel}/build
rm -f ${root_dir}/lib/modules/${ker_rel}/source

if [ "${ARCH}" = "arm" ]; then
  cp ${KERNEL_SRC}/arch/${ARCH}/boot/zImage ${root_dir}/boot/${img_name}
  cp ${KERNEL_SRC}/arch/${ARCH}/boot/dts/*.dtb ${root_dir}/boot
else
  cp ${KERNEL_SRC}/arch/${ARCH}/boot/Image ${root_dir}/boot/${img_name}
  cp ${KERNEL_SRC}/arch/${ARCH}/boot/dts/broadcom/*.dtb ${root_dir}/boot
fi
cp ${KERNEL_SRC}/arch/${ARCH}/boot/dts/overlays/*.dtb* ${root_dir}/boot/overlays
cp ${KERNEL_SRC}/arch/${ARCH}/boot/dts/overlays/README ${root_dir}/boot/overlays

fakeroot tar czf ${arch_name} -C ${root_dir} boot/ lib/
rm -rf ${root_dir}
