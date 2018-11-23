#!/bin/bash

MODULE="./minix.ko"
PROGNAMELEN=`expr ${#MODULE} - 5`
MODULE_NAME=${MODULE:2:$PROGNAMELEN}
FILE_ADDR="./file/file"
MINIX_PART="./minix.img"

init()
{
  make clean
  make

  if [ $? -eq 0 ]; then
      clear
      clear
  fi

  if [ -e $MINIX_PART ]
  then
  {
    sudo umount loop1
    sudo ./MinixPartition.sh "-m"
    rmModule
  }
  else
  {
    sudo umount loop1
    sudo ./MinixPartition.sh "-n"
    rmModule
  }
  fi

  if [ $? -eq 0 ]; then
      clear
      clear
  fi
}

insModule()
{
  printf  "\n\tInserting Module with key='$1'\n"
  sudo insmod $MODULE key=$1
  sudo ./MinixPartition.sh "-m"
}

rmModule()
{
  sudo ./MinixPartition.sh "-u"
  sudo rmmod $MODULE_NAME
}

copyFile()
{
  ORIG=$1
  DEST=$2
  cp $ORIG $DEST
}

readFile()
{
  FILE=$1
  printf  "\tRead  from $1: "
  cat $1
}

writeFile()
{
  FILE=$1
  DATA=$2
  printf  "\tWrite into $1\n"
  echo $2 >$1
}


init
printf  "\n\n================================================================================\n\n"

  insModule "000102030405060708090A0B0C0D0E0F"
    writeFile $FILE_ADDR "01 02 03 04 05 06"
    readFile  $FILE_ADDR

    copyFile  "./tinyTale.txt" "./file/tinyTale.txt"
    printf    "\n\n"
    readFile  "./file/tinyTale.txt"
  rmModule

  insModule "00000000000000000000000000000000"
    readFile  $FILE_ADDR
    printf    "\n\n"
    readFile  "./file/tinyTale.txt"
  rmModule

printf  "\n================================================================================\n\n"
