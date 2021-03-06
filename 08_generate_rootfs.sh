#!/bin/sh

cd work

rm -rf rootfs  #probably redo this to use a absolute path

cd busybox
cd $(ls -d *)

# Copy all BusyBox generated stuff to the location of our "initramfs" folder.
cp -R _install ../../rootfs

# Install static python
#cd ../../python
#cp python* ../rootfs/usr/bin/python
#chmod +x ../rootfs/usr/bin/python

# prepare rootfs
#ls ../../
cd ../../rootfs

# Remove "linuxrc" which is used when we boot in "RAM disk" mode. 
rm -f linuxrc #probably redo this to use a absolute path

# Create root FS folders
mkdir dev
mkdir etc
mkdir proc
mkdir root
mkdir src
mkdir sys
mkdir tmp

# "1" means that only the owner of a file/directory (or root) can remove it.
chmod 1777 tmp

cd etc

# The script "/etc/bootscript.sh" is automatically executed as part of the
# "init" proess. We suppress most kernel messages, mount all crytical file
# systems, loop through all available network devices and we configure them
# through DHCP.
cat > bootscript.sh << EOF
#!/bin/sh

dmesg -n 1
mount -t devtmpfs none /dev
mount -t proc none /proc
mount -t sysfs none /sys

ip link set eth0 up
udhcpc -b -i eth0 -s /etc/rc.dhcp

EOF

chmod +x bootscript.sh

# The script "/etc/rc.dhcp" is automatically invoked for each network device. 
cat > rc.dhcp << EOF
#!/bin/sh

ip addr add \$ip/\$mask dev \$interface

if [ "\$router" ]; then
  ip route add default via \$router dev \$interface
fi

EOF

chmod +x rc.dhcp

# DNS resolving is done by using Google's public DNS servers
cat > resolv.conf << EOF
nameserver 8.8.8.8
nameserver 8.8.4.4

EOF

# The file "/etc/welcome.txt" is displayed on every boot of the system in each
# available terminal.
cat > welcome.txt << EOF

      ________       ___      __   __ 
      \_____  \   __| _/____ |  | |__| ____  __ _____  ___
       /   / \ \ / __ |/ __ \|  | |  |/    \|  |  \  \/  /
      /   |__|  \ /_/ \  ___/|  |_|  |   |  \  |  />    <
      \_________/_____|\_____\____/__|___|__/____//__/\__\

                         Odelinux v0.02
                            10/15/18


EOF

cat > patchnotes.txt << EOF

03/16/16 - Only resolving eth0 now
03/16/16 - Fixed a build issue, booting the whole file now, not 4 sectors
03/10/16 - Added python
03/10/16 - Initial version - 0.01
10/15/18 - v0.02, kernel 4.18, busybox 1.29.3, no python for now

EOF

# The file "/etc/inittab" contains the configuration which defines how the
# system will be initialized. Check the following URL for more details:
# http://git.busybox.net/busybox/tree/examples/inittab
cat > inittab << EOF
::sysinit:/etc/bootscript.sh
::restart:/sbin/init
::ctrlaltdel:/sbin/reboot
::once:cat /etc/welcome.txt
::respawn:/bin/cttyhack /bin/sh
tty2::once:cat /etc/welcome.txt
tty2::respawn:/bin/sh
tty3::once:cat /etc/welcome.txt
tty3::respawn:/bin/sh
tty4::once:cat /etc/welcome.txt
tty4::respawn:/bin/sh

EOF

cd ..

# The "/init" script passes the execution to "/sbin/init" which in turn looks
# for the configuration file "/etc/inittab".
cat > init << EOF
#!/bin/sh

exec /sbin/init

EOF

chmod +x init

# Copy all source files to "/src". Note that the scripts won't work there.
cp ../../*.sh src
cp ../../.config src
chmod +r src/*.sh
chmod +r src/.config

cd ../..

