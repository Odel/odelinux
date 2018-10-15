#!/bin/sh
cd work/kernel
cd $(ls -d *)
WORK_KERNEL_DIR=$(pwd)
cd ../../..

rm -f minimal_linux_live.iso
rm -rf work/isoimage

# This is the root folder of the ISO image
mkdir work/isoimage
cd work/isoimage

# Search and copy the files 'isolinux.bin' and 'ldlinux.c32'
for i in lib lib64 share end ; do
    if [ -f usr/$i/syslinux/isolinux.bin ]; then
        cp /usr/$i/syslinux/isolinux.bin .
        if [ -f /usr/$i/syslinux/ldlinux.c32 ]; then
            cp /usr/$i/syslinux/ldlinux.c32 .
        fi;
        break;
    fi;
    if [ $i = end ]; then exit 1; fi;
done

# Now we copy the kernel
cp $WORK_KERNEL_DIR/arch/x86/boot/bzImage ./kernel.bz

# Now we copy the root file system
cp ../rootfs.cpio.gz ./rootfs.gz

# Copy all source files to "/src". Note that the scripts won't work there.
mkdir src
cp ../../*.sh src
cp ../../.config src
chmod +rx src/*.sh
chmod +r src/.config

# Create ISOLINUX configuration file
echo 'default kernel.bz  initrd=rootfs.gz' > ./isolinux.cfg

# Now we generate the ISO image file
genisoimage -J -r -o ../odelinux_linux_live.iso -b isolinux.bin -c boot.cat -no-emul-boot -boot-info-table ./

# This allows the ISO image to be bootable if it is burned on USB flash drive
isohybrid ../odelinux_linux_live.iso 2>/dev/null || true

# Copy the ISO image to the root project folder
cp ../odelinux_linux_live.iso ../../

cd ../..

