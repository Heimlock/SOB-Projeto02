#
# Makefile for the Linux minix filesystem routines.
#

obj-m += minix.o
CFLAGS_minix.o :=	-DDEBUG

minix-objs := ./CustomFunctions/Cipher.o ./CustomFunctions/AuxiliaryFunctions.o ./CustomFunctions/file.o ./CustomFunctions/inode.o ./minix/bitmap.o ./minix/itree_v1.o ./minix/itree_v2.o ./minix/namei.o ./minix/dir.o

all:
	clear
	clear
	@rm	-f minix.ko
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules
	@rm -f *.mod.c *.mod.o *.o

clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
	rm -f other/ioctl other/cat_noblock *.plist test_cryptomodule
