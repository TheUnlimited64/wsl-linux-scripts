#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

CONFIG_X86_X32=$(expr $(nproc) - 1)
git clone https://github.com/microsoft/WSL2-Linux-Kernel
sudo apt update
sudo apt install -y dwarves bc flex bison build-essential libelf-dev libncurses-dev libssl-dev dwarves python3
cp .config WSL2-Linux-Kernel/.config
cd WSL2-Linux-Kernel
git switch linux-msft-wsl-5.15.y
export KERNELRELEASE=$(uname -r)
make KERNELRELEASE=$KERNELRELEASE -j8
make KERNELRELEASE=$KERNELRELEASE modules -j8
sudo make KERNELRELEASE=$KERNELRELEASE modules_install 
sudo mount -t debugfs debugfs /sys/kernel/debug
USERNAME=$(/mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0/powershell.exe '$env:UserName' | tr -cd '[:alpha:]')
sudo cp arch/x86/boot/bzImage "/mnt/c/Users/${USERNAME}/bzImage"
echo "kernel=C:\\\\Users\\\\$USERNAME\\\\bzImage">>.wslconfig
sudo cp .wslconfig "/mnt/c/Users/${USERNAME}/.wslconfig"
echo "wsl --shutdown" | /mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0/powershell.exe
