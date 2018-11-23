#!/bin/bash

IMAGENAME="minix.img"
MOUNT_DIR="./file"
BLK_SIZE="1k"
BLK_COUNT=10000
LOOP_DEV="/dev/loop1"

####################
##    General     ##
####################

help()
{
    echo    "Auxiliary Script for (De)Monting a Minix Partition"
    echo    "General Commands:"
    echo    "-m         ==  Mounts the Partition"
    echo    "-u         ==  Demounts the Partition"
    echo    "-n         ==  Creates a New Partition"
    echo    "-h         ==  Show this Message"
}

switch()
{
    case $1 in
    "-m")
        mount
        ;;
    "-u")
        umount
        ;;
    "-n")
        new_img
        ;;
    *)
        help
        ;;
    esac
}

####################
##    Commands    ##
####################
new_img()
{
    dd if=/dev/zero of=$IMAGENAME bs=$BLK_SIZE count=$BLK_COUNT
    sudo mkdir $MOUNT_DIR
    sudo mkfs.minix $LOOP_DEV
    sudo mkfs.minix $LOOP_DEV
    sudo mount -t minix $LOOP_DEV $MOUNT_DIR
    sudo chmod a+rwx $MOUNT_DIR
}

mount()
{
    sudo umount $LOOP_DEV
    sudo losetup $LOOP_DEV ./$IMAGENAME
    sudo mount -t minix $LOOP_DEV $MOUNT_DIR
    sudo chmod a+rwx $MOUNT_DIR
    printf  "\t$IMAGENAME Mounted\n"
}

umount()
{
  sudo umount  $MOUNT_DIR
  # sudo umount  $LOOP_DEV
  printf  "\t$IMAGENAME Demounted\n"
}

main()
{
  if [ $EUID -ne 0 ]  ##  Verify if it's a sudo command
  then
      sudo $0 $@
  else
      if [ $# = 0 ]  ##  Verify if has no Arguments
      then
          help
          printf  "$0 Terminated\n"
      else
          switch $1
      fi
  fi
}

main  $@
