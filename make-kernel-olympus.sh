#!/bin/bash

export PLATFORM_DIR=~/cm9
export KERNEL_BUILD_OUT=$PLATFORM_DIR/kernel/tegra-temp
export ARCH=arm
export CROSS_COMPILE=$PLATFORM_DIR/prebuilt/linux-x86/toolchain/arm-eabi-4.4.0/bin/arm-eabi-
export KERNEL_SRC=$PLATFORM_DIR/kernel/tegra-atrix
KBUILD_BUILD_VERSION="joker-cm9-beta"
export KBUILD_BUILD_VERSION
make distclean
make -j1 -C $KERNEL_SRC O=$KERNEL_BUILD_OUT KBUILD_DEFCONFIG=tegra_olympus_cyanogenmod_defconfig defconfig menuconfig modules_prepare
make -j1 -C $KERNEL_SRC O=$KERNEL_BUILD_OUT DEPMOD=out/host/linux-x86/bin/depmod INSTALL_MOD_PATH=$KERNEL_BUILD_OUT modules
make -j1 -C $KERNEL_SRC O=$KERNEL_BUILD_OUT DEPMOD=out/host/linux-x86/bin/depmod INSTALL_MOD_PATH=$KERNEL_BUILD_OUT modules_install
make -j1 -C $KERNEL_SRC O=$KERNEL_BUILD_OUT zImage
make -j1 -C $KERNEL_SRC O=$KERNEL_BUILD_OUT DEPMOD=out/host/linux-x86/bin/depmod INSTALL_MOD_PATH=$KERNEL_BUILD_OUT M=$PLATFORM_DIR/vendor/authentec/safenet/vpndriver modules
export ANDROID_BUILD_TOP=/$PLATFORM_DIR
export LINUXSRCDIR=$KERNEL_SRC
export LINUXBUILDDIR=$PLATFORM_DIR/kernel/tegra-temp
export CROSS_COMPILE=$PLATFORM_DIR/prebuilt/linux-x86/toolchain/arm-eabi-4.4.0/bin/arm-eabi-
make -C $PLATFORM_DIR/vendor/bcm/wlan/osrc/open-src/src/dhd/linux 
cp kernel/tegra-temp/arch/arm/boot/zImage device/moto/olympus/kernel
cp vendor/authentec/safenet/vpndriver/vpnclient.ko device/moto/olympus/modules
cp vendor/bcm/wlan/osrc/open-src/src/dhd/linux/dhd.ko device/moto/olympus/modules
