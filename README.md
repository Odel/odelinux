Odelinux v0.02

Tiny linux "distro", initially based on minimal linux: http://minimal.linux-bg.org/

Make sure these are installed:
bison
build-essential
flex
git
libelf-dev
libssl-dev

git clone https://gitlab.com/Odel/Odelinux.git
cd Odelinux
./build_odelinux_live.sh

to test in qemu (install with apt-get install qemu)
./qemu64.sh