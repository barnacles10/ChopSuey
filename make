#!/bin/bash
# Build the kernel without your mom.

if [ $# -ne 1 ]; then
	echo "Written by Lithid"
	echo "Kanged by barnacles10"
        echo "[Error]: Expected 1 parameter, got $#."
        echo "Usage: bash build-it.sh v# [BUILD VERSION]"
        exit 99
else
	echo "[x] $1"
fi

MY_HOME=$(pwd)
VERSION="$1"
MY_CONFIG="barnacles10_supersonic_defconfig"
AUTO_SIGN="$MY_HOME/prebuilt/auto-sign"
USE_PREBUILT="$MY_HOME/prebuilt/linux-x86/toolchain/arm-eabi-4.4.3/bin/arm-eabi-"
ANY_MODULES="$MY_HOME/any-kernel/system/lib/modules"
ANY_MODULES_SYN_NIGHTLY="$MY_HOME/any-kernel/data/Synergy-System/system.lib/modules"
ANY_KERNEL="$MY_HOME/any-kernel/kernel"
ANY_KERNEL_HOME="$MY_HOME/any-kernel"
ANY_KERNEL_UPDATER_SCRIPT="$ANY_KERNEL_HOME/META-INF/com/google/android/updater-script"
PLACEHOLDER="$ANY_MODULES/PLACEHOLDER"
DATE=$(date +%m%d%Y)

if [ -f $PLACEHOLDER ]; then
	rm $PLACEHOLDER
fi

cp $MY_HOME/arch/arm/configs/$MY_CONFIG $MY_HOME/.config
if [ -f $MY_HOME/.config ]; then
	echo "[x] .config"
else
	echo "No .config file found. Can't Proceed."
	exit 98
fi

function check_finished_paths(){
if [ -f $CHECK_PATH ]; then
	echo "Moving $CHECK_PATH to any-kernel-updater"
	cp $CHECK_PATH $FINAL_PATH
else
	echo "Sorry Somthing went wrong and your $CHECK_PATH isn't there: EXITING"
	exit 97
fi
}

function just_sign_the_fucking_zip(){
cd $ANY_KERNEL_HOME
zip -r $THIS_ZIP *
mv $THIS_ZIP $AUTO_SIGN/
cd $AUTO_SIGN
echo "Signing $THIS_ZIP"
java -jar signapk.jar certificate.pem key.pk8 $THIS_ZIP $THIS_ZIP-signed
rm $THIS_ZIP
mv $THIS_ZIP-signed $HOME/$THIS_ZIP_SIGNED
cd $MY_HOME
}

function universal_updater_script(){
rm $ANY_KERNEL_UPDATER_SCRIPT
(cat << EOF) | sed s/_VER_/$VERSION/g > $ANY_KERNEL_UPDATER_SCRIPT
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");
ui_print("CHOPSUEY KERNEL _VER_        Version: Universal");
ui_print("Developed by: barnacles10    Device: HTC Evo 4g");
ui_print("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");
ui_print("");
ui_print("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");
ui_print("     Using: AnyKernel Updater by Koush.");
ui_print("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
set_progress(1.000000); 
ui_print("Extracting System Files...");
mount("MTD", "system", "/system");
package_extract_dir("system", "/system");
unmount("/system"); 
show_progress(0.500000, 20);
ui_print("Extracting Kernel files...");
package_extract_dir("kernel", "/tmp");
ui_print("Installing kernel...");
set_perm(0, 0, 0777, "/tmp/dump_image");
set_perm(0, 0, 0777, "/tmp/mkbootimg.sh");
set_perm(0, 0, 0777, "/tmp/mkbootimg");
set_perm(0, 0, 0777, "/tmp/unpackbootimg");
show_progress(0.500000, 30);
run_program("/tmp/dump_image", "boot", "/tmp/boot.img");
show_progress(0.500000, 50);
run_program("/tmp/unpackbootimg", "/tmp/boot.img", "/tmp/");
show_progress(0.500000, 60);
run_program("/tmp/mkbootimg.sh");
show_progress(0.500000, 80);
write_raw_image("/tmp/newboot.img", "boot");
ui_print("Your now running ChopSuey!!");
show_progress(0.500000, 100);
EOF
}

function syn_nightly_updater_script(){
rm $ANY_KERNEL_UPDATER_SCRIPT
(cat << EOF) | sed s/_VER_/$VERSION/g > $ANY_KERNEL_UPDATER_SCRIPT
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");
ui_print("CHOPSUEY KERNEL _VER_  Version: Synergy Nightly");
ui_print("Developed by: barnacles10    Device: HTC Evo 4g");
ui_print("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");
ui_print("");
ui_print("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");
ui_print("     Using: AnyKernel Updater by Koush.");
ui_print("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
set_progress(1.000000); 
mount("MTD", "userdata", "/data");
package_extract_dir("data", "/data");
set_perm_recursive(0, 0, 0755, 0644, "/data/Synergy-System/syste.lib/modules");
unmount("/data");
mount("MTD", "system", "/system");
package_extract_dir("system", "/system");
set_perm_recursive(0, 0, 0755, 0644, "/system/lib/modules");
set_perm_recursive(0, 0, 0755, 0755, "/system/etc/init.d");
unmount("/system");
ui_print("Extracting Kernel files...");
package_extract_dir("kernel", "/tmp");
ui_print("Installing kernel...");
set_perm(0, 0, 0777, "/tmp/dump_image");
set_perm(0, 0, 0777, "/tmp/mkbootimg.sh");
set_perm(0, 0, 0777, "/tmp/mkbootimg");
set_perm(0, 0, 0777, "/tmp/unpackbootimg");
run_program("/tmp/dump_image", "boot", "/tmp/boot.img");
run_program("/tmp/unpackbootimg", "/tmp/boot.img", "/tmp/");
run_program("/tmp/mkbootimg.sh");
format("MTD", "boot");
write_raw_image("/tmp/newboot.img", "boot");ui_print("");
format ("MTD", "cache");
ui_print("Your now running ChopSuey!");
EOF
}

function synergy_godmode_updater_script(){
rm $ANY_KERNEL_UPDATER_SCRIPT
(cat << EOF) | sed s/_VER_/$VERSION/g > $ANY_KERNEL_UPDATER_SCRIPT
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");
ui_print("CHOPSUEY KERNEL _VER_  Version: Synergy Godmode");
ui_print("Developed by: barnacles10    Device: HTC Evo 4g");
ui_print("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");
ui_print("");
ui_print("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");
ui_print("     Using: AnyKernel Updater by Koush.");
ui_print("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
set_progress(1.000000); 
ui_print("Extracting System Files...");
run_program("/sbin/busybox", "mkdir", "/system0");
run_program("/sbin/busybox", "mount", "-t", "auto", "/dev/block/mtdblock4", "/system0");
run_program("/sbin/busybox", "mount", "-t", "ext2", "-o", "loop", "/system0/system.img", "/system");
package_extract_dir("system", "/system");
unmount("/system");
unmount("/system0");;
show_progress(0.500000, 20);
ui_print("Extracting Kernel files...");
package_extract_dir("kernel", "/tmp");
ui_print("Installing kernel...");
set_perm(0, 0, 0777, "/tmp/dump_image");
set_perm(0, 0, 0777, "/tmp/mkbootimg.sh");
set_perm(0, 0, 0777, "/tmp/mkbootimg");
set_perm(0, 0, 0777, "/tmp/unpackbootimg");
show_progress(0.500000, 30);
run_program("/tmp/dump_image", "boot", "/tmp/boot.img");
show_progress(0.500000, 50);
run_program("/tmp/unpackbootimg", "/tmp/boot.img", "/tmp/");
show_progress(0.500000, 60);
run_program("/tmp/mkbootimg.sh");
show_progress(0.500000, 80);
write_raw_image("/tmp/newboot.img", "boot");
ui_print("ChopSuey Kernel for Synergy Godmode Complete!");
show_progress(0.500000, 100);
EOF
}

function remove_syn_nightly_fix(){
if [ -d $ANY_MODULES_SYN_NIGHTLY ]; then
	rm -r $ANY_KERNEL_HOME/data &>> /dev/null
fi

if [ -d $ANY_MODULES ]; then
	echo "$ANY_MODULES is here"
else
	mkdir -p $ANY_MODULES
fi
}

function universal_modules_kernel_migration(){
remove_syn_nightly_fix

# For the modules
CHECK_PATH="$MY_HOME/drivers/net/wimax/SQN/sequans_sdio.ko"
FINAL_PATH="$ANY_MODULES/"
check_finished_paths
CHECK_PATH="$MY_HOME/drivers/net/wimax/wimaxdbg/wimaxdbg.ko"
FINAL_PATH="$ANY_MODULES/"
check_finished_paths
CHECK_PATH="$MY_HOME/drivers/net/wimax/wimaxuart/wimaxuart.ko"
FINAL_PATH="$ANY_MODULES/"
check_finished_paths
CHECK_PATH="$MY_HOME/drivers/net/wireless/bcm4329_204/bcm4329.ko"
FINAL_PATH="$ANY_MODULES/"
check_finished_paths

# For the kernel
CHECK_PATH="$MY_HOME/arch/arm/boot/zImage"
FINAL_PATH="$ANY_KERNEL/"
check_finished_paths

if [ "$TYPE" == "SYNERGY_GODMODE" ]; then
	synergy_godmode_updater_script
elif [ "$TYPE" == "UNIVERSAL" ]; then
	universal_updater_script
else
	echo "You are trying to use an updater that isn't correct"
	exit 93
fi
}

function syn_nightly_modules_kernel_migration(){
if [ -d $ANY_MODULES ]; then
	rm -r $ANY_KERNEL_HOME/system &>> /dev/null
fi

if [ -d $ANY_MODULES_SYN_NIGHTLY  ]; then
	echo "Using Path: $ANY_MODULES_SYN_NIGHTLY "
else
	mkdir -p $ANY_MODULES_SYN_NIGHTLY 
fi

# For the modules
CHECK_PATH="$MY_HOME/drivers/net/wimax/SQN/sequans_sdio.ko"
FINAL_PATH="$ANY_MODULES_SYN_NIGHTLY/"
check_finished_paths
CHECK_PATH="$MY_HOME/drivers/net/wimax/wimaxdbg/wimaxdbg.ko"
FINAL_PATH="$ANY_MODULES_SYN_NIGHTLY/"
check_finished_paths
CHECK_PATH="$MY_HOME/drivers/net/wimax/wimaxuart/wimaxuart.ko"
FINAL_PATH="$ANY_MODULES_SYN_NIGHTLY/"
check_finished_paths
CHECK_PATH="$MY_HOME/drivers/net/wireless/bcm4329_204/bcm4329.ko"
FINAL_PATH="$ANY_MODULES_SYN_NIGHTLY/"
check_finished_paths

# For the kernel
CHECK_PATH="$MY_HOME/arch/arm/boot/zImage"
FINAL_PATH="$ANY_KERNEL/"
check_finished_paths

if [ "$TYPE" == "SYN_NIGHTLY" ]; then
	syn_nightly_updater_script
else
	echo "Something went wrong. Sorry"
	exit 95
fi

}

sed "s/CONFIG_LOCALVERSION=".*"/CONFIG_LOCALVERSION="\"-ChopSuey-$1\""/g" .config > tmp
mv tmp .config

echo "Using pre-built tool: $USE_PREBUILT"
export COMPILER=$USE_PREBUILT

make -j$(grep -ic ^processor /proc/cpuinfo) ARCH=arm CROSS_COMPILE=$COMPILER

TYPE="UNIVERSAL"
universal_modules_kernel_migration
THIS_ZIP="ChopSuey-$1-$TYPE.zip"
THIS_ZIP_SIGNED="ChopSuey-$1-$TYPE-signed.zip"
just_sign_the_fucking_zip

TYPE="SYN_NIGHTLY"
syn_nightly_modules_kernel_migration
THIS_ZIP="ChopSuey-$1-$TYPE.zip"
THIS_ZIP_SIGNED="ChopSuey$1-$TYPE-signed.zip"
just_sign_the_fucking_zip

TYPE="SYNERGY_GODMODE"
universal_modules_kernel_migration
THIS_ZIP="ChopSuey-$1-$TYPE.zip"
THIS_ZIP_SIGNED="ChopSuey-$1-$TYPE-signed.zip"
just_sign_the_fucking_zip

make distclean
remove_syn_nightly_fix
echo "Cleaning the any-kernel modules"
rm $ANY_MODULES/*.ko &>> /dev/null
echo "Cleaning the any-kernel zimage"
rm $ANY_KERNEL/zImage &>> /dev/null
echo "Cleaning the auto-sign folder"
rm $AUTO_SIGN/*.zip &>> /dev/null

universal_updater_script
touch $MY_HOME/any-kernel/system/lib/modules/PLACEHOLDER

THIS_ZIP_SIGNED="ChopSuey-*signed.zip"
FINAL_INSTALL_ZIP=$(find $HOME -iname $THIS_ZIP_SIGNED |grep -v .local)
echo ""
echo ""
echo "Your files are located: $FINAL_INSTALL_ZIP"

exit
