#
# Make an olympus kernel - minor config capabilities
#
# !@ acerbix - 2012
#

export ARCH=arm 
export CROSS_COMPILE=~/code/android/system-9/prebuilt/linux-x86/toolchain/arm-eabi-4.4.3/bin/arm-eabi- 
X_ARG=-j4
PLATFORM=tegra_olympus_android_defconfig

DEFCONFIG=0
DISTCLEAN=0
MENUCONFIG=0

while getopts :a:c:x:p:dm opts; do
	case $opts in
	a)
		export ARCH=$OPTARG
		echo "Set ARCH to ${OPTARG}"
		;;
	c)
		export CROSS_COMPILE=$OPTARG
		echo "Set CROSS_COMPILE to ${OPTARG}"
		;;
	x)
		X_ARG=$OPTARG
		echo "Set make flag to ${OPTARG}"
		;;
	p)
		PLATFORM=$OPTARG
		echo "Set Platform to ${OPTARG}"
		;;
	d)	
		DEFCONFIG=1;
		DISTCLEAN=1;
		;;
	m)
		MENUCONFIG=1;
		DEFCONFIG=1;
		DISTCLEAN=1;
		;;
	\?)	
		cat <<EOF
		Kernel compiler v 1.0 for motorola atrix/tegra based devices
		(c) acerbix 2012

		Options:
		-a <processor> - default - arm
		-c <cross compiler path> - default - will probably not work for you. 
		   At least edit this file and set the CROSS_COMPILE value
		-x <parallel make arg> - default -j4
		-p <config> - default - tegra_olympus_android_defconfig
		-d - run distclean and defconfig before make
		-m - run distclean, defconfig, and menuconfig before make
		
EOF
		exit 1
		;;
	:)
		echo "Option -${OPTARG} needs an argument"
		exit 1
		;;
	esac
done



	




if [ $DISTCLEAN -eq 1 ]
	then
		echo "Distclean"
		make distclean
fi

if [ $DEFCONFIG -eq 1 ]
	then
		echo "Defconfig"
		make $PLATFORM
fi

if [ $MENUCONFIG -eq 1 ]
	then
		echo "Menuconfig"
		make menuconfig
fi

make $X_ARG zImage

make $X_ARG modules
