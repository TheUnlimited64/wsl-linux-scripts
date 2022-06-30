#!/bin/bash
set -e 
sudo apt install -y gcc gdb cmake vim 
VARIABLE=$(echo $(pwd) | sed 's/\/mnt\/c//')
echo $VARIABLE
./helper/run_powershell_script -p $(pwd) -n "kex.ps1"
./kex.zsh