Odelinux v0.01

Tiny linux "distro", initially based on minimal linux: http://minimal.linux-bg.org/

Make sure git and build-essential are installed (I'm building this on Ubuntu)
apt-get install git build-essential musl-tools

Make sure isolinux.bin exists in /usr/lib/syslinux/isolinux.bin (I found one online, I'll look at making one later)

git clone https://gitlab.com/Odel/Odelinux.git
cd Odelinux
./build_odelinux_live.sh

to test in qemu (install with apt-get install qemu)
./qemu64.sh