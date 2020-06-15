#!/bin/sh

if [ "${ARCH}x" = "x"  -o "${CROSS_COMPILE}x" = "x" -o "${KERNEL_SRC}x" = "x" ]; then
  echo "ERROR: Building environment must be properly set"
  exit 1
fi

if [ "${ARCH}" != "arm" ]; then
  echo "ERROR: Invalid architecture set in ARCH; Supported architectures: arm"
  exit 1
fi

echo "Building for"
echo "1) RPi 1"
echo "2) RPi 2/3"
echo "3) RPi 4"
echo "4) Go to packaging"

read -p ":" CHOICE

case ${CHOICE} in
  1) BLD_TARGET=bcmrpi_defconfig;;
  2) BLD_TARGET=bcm2709_defconfig;;
  3) BLD_TARGET=bcm2711_defconfig;;
  4) BLD_TARGET=;;
  *) echo "ERROR: Invalid input"; exit 1;;
esac

if [ "${BLD_TARGET}x" != "x" ]; then
  make -C ${KERNEL_SRC} ${BLD_TARGET}
  make -C ${KERNEL_SRC} -j4
fi

ROOT_DIR=.rpi_root
KERN_REL=`make -s -C ${KERNEL_SRC} kernelrelease`
KERN_VER=`make -s -C ${KERNEL_SRC} kernelversion`

case $(echo ${KERN_REL} | sed "s/${KERN_VER}\(.*\)/\\1/") in
    +) IMG_NAME=kernel.img;;
    -v7+) IMG_NAME=kernel7.img;;
    -v7l+) IMG_NAME=kernel7l.img;;
    *) echo "ERROR: Kernel release not recognized"; exit 1;;
esac

mkdir ${ROOT_DIR}
mkdir ${ROOT_DIR}/boot
mkdir ${ROOT_DIR}/boot/overlays

INSTALL_MOD_PATH=`pwd`/${ROOT_DIR} make -C ${KERNEL_SRC} modules_install
rm -f ${ROOT_DIR}/lib/modules/${KERN_REL}/build
rm -f ${ROOT_DIR}/lib/modules/${KERN_REL}/source

cp ${KERNEL_SRC}/arch/${ARCH}/boot/zImage ${ROOT_DIR}/boot/${IMG_NAME}

cp ${KERNEL_SRC}/arch/${ARCH}/boot/dts/*.dtb ${ROOT_DIR}/boot
cp ${KERNEL_SRC}/arch/${ARCH}/boot/dts/overlays/*.dtb* ${ROOT_DIR}/boot/overlays
cp ${KERNEL_SRC}/arch/${ARCH}/boot/dts/overlays/README ${ROOT_DIR}/boot/overlays

fakeroot tar czf kernel-${KERN_REL}.tar.gz -C ${ROOT_DIR} boot/ lib/
rm -rf ${ROOT_DIR}
