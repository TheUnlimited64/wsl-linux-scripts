#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
git clone https://github.com/microsoft/WSL2-Linux-Kernel.git
sudo apt install -y flex bison build-essential libelf-dev libncurses-dev libssl-dev dwarves btf python3
cp .config WSL2-Linux-Kernel/.config
cd WSL2-Linux-Kernel
export KERNELRELEASE=$(uname -r)
make KERNELRELEASE=$KERNELRELEASE
make KERNELRELEASE=$KERNELRELEASE modules -j 4
sudo make KERNELRELEASE=$KERNELRELEASE modules_install 
sudo mount -t debugfs debugfs /sys/kernel/debug
USERNAME=$(powershell.exe '$env:UserName' | tr -d \r)
sudo cp arch/x86/boot/bzImage "/mnt/c/Users/${USERNAME}/bzImage"
sudo cp .wslconfig "/mnt/c/Users/${USERNAME}/.wslconfig"
echo "kernel=C:\\\\Users\\\\$USERNAME\\\\bzImage">>.wslconfig
#./helper/run_powershell_script -p ${pwd} -n "shutdown_wsl.ps1"
echo "wsl --shutdown" | powershell.exe
