#!/bin/bash

make

printf  "\n\n================================================================================\n\n"

sudo insmod ./minix.ko
sudo ./MinixPartition.sh "-m"
  printf  "\tWrite into ./file/file\n"
  echo "01 02 03 04 05 06" >./file/file
  printf  "\tRead  from ./file/file : "
  cat ./file/file
sudo ./MinixPartition.sh "-u"
sudo rmmod minix

printf  "\n================================================================================\n\n"
