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
CM9_TOP="../../"
DO_COPY=0
while getopts :a:c:x:p:n:dm opts; do
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
	n)
		CM9_TOP=$OPTARG
		DO_COPY=1
		echo "Set CM9 top dir to ${OPTARG}"
		;;
	d)	
		DEFCONFIG=1;
		DISTCLEAN=1;
		;;
	m)
		MENUCONFIG=1;
		
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
		-n <CM9 top level directory> - copy kernel and modules to CM9 	
EOF
		exit 1
		;;
	:)
		if [ $OPTARG == "n" ] 
			then
				echo "Set CM9 top dir to ${CM9_TOP}"	
				DO_COPY=1
			else
				echo "Option -${OPTARG} needs an argument"
				exit 1
		fi
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

make clean

make $X_ARG zImage
make $X_ARG modules


if [ $DO_COPY -eq 1 ]
	then
		echo "Copyng kernel to ${CM9_TOP}/device/moto/olympus/kernel"
		cp arch/$ARCH/boot/zImage ${CM9_TOP}/device/moto/olympus/kernel
		touch ${CM9_TOP}/device/moto/olympus/kernel
		echo "Copyng modules to ${CM9_TOP}/device/moto/olympus/modules/"
		for mod in `find  .  -name "*.ko" -print `;  
			do   cp  $mod "${CM9_TOP}/device/moto/olympus/modules/" ; done 
fi

echo Finished at `date`

