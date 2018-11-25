#!/bin/bash

 #
 #		Sistemas Operacionais B
 #		Projeto 02 - Minix Cifrado
 #
 #	Integrantes:
 #		Bruno Pereira Bannwart        RA: 15171572
 #		Felipe Moreira Ferreira       RA: 16116469
 #		Luiz Felipe Zerbetto Masson   RA: 15166804
 #		Matheus Manganeli de Macedo   RA: 16250276
 #		Rodrigo da Silva Cardoso      RA: 16430126
 #
 #	 Testes Automáticos
 #

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

  if [ -e $MINIX_PART ]; then
  {
    sudo ./MinixPartition.sh "-m"
    rmModule
  }
  else
  {
    sudo ./MinixPartition.sh "-n"
    rmModule
  }
  fi

  if [ $? -eq 0 ]; then
      clear
      clear
  fi
}

 #
 #  insmod
 #    Função que Insere o $MODULE com uma dada Chave Criptográfica
 #  Argumentos:
 #    $1  ==  Chave Criptográfica
 #
insModule()
{
  printf  "\n\tInserting Module with key='$1'\n"
  sudo insmod $MODULE key=$1
  sudo ./MinixPartition.sh "-m"
}

 #
 #  rmModule
 #    Função que Remove o $MODULE
 #
rmModule()
{
  sudo ./MinixPartition.sh "-u"
  sudo rmmod $MODULE_NAME
}

 #
 #  copyFile
 #    Função que Copia Arquivo(s)
 #  Argumentos:
 #    $1  ==  Path do Arquivo Original
 #    $2  ==  Path Destino
 #
copyFile()
{
  ORIG=$1
  DEST=$2
  cp $ORIG $DEST
}

 #
 #  readFile
 #    Função que Lê um dado Arquivo
 #  Argumentos:
 #    $1  ==  Path do Arquivo
 #
readFile()
{
  printf  "\tRead  from $1: \n"
  cat $1
}

 #
 #  writeFile
 #    Função que Escreve Dados em um Arquivo
 #  Argumentos:
 #    $1  ==  Path do Arquivo
 #    $2  ==  Dados
 #
writeFile()
{
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
