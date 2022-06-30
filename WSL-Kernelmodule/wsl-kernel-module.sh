#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
git clone https://github.com/microsoft/WSL2-Linux-Kernel.git
sudo apt install flex bison build-essential libelf-dev libncurses-dev  libssl-dev dwarves btf python3
cp .config WSL2-Linux-Kernel/.config
cd WSL2-Linux-Kernel
export KERNELRELEASE=$(uname -r)
make KERNELRELEASE=$KERNELRELEASE
make KERNELRELEASE=$KERNELRELEASE modules -j 4
sudo make KERNELRELEASE=$KERNELRELEASE modules_install 
sudo mount -t debugfs debugfs /sys/kernel/debug
echo "Now move bzImage from WSL2-Linux-Kernel/arch/x86/boot/bzImage to C:/Users/<user>/bzImage"
echo "Copy .wslconfig to C:/Users/<user>/.wslconfig (Note: change username in path), then do wsl --shutdown in powershell" 
