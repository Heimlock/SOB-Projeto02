
/*
 *		Sistemas Operacionais B
 *		Projeto 02 - Minix Cifrado
 *
 *	Integrantes:
 *		Bruno Pereira Bannwart        RA: 15171572
 *		Felipe Moreira Ferreira       RA: 16116469
 *		Luiz Felipe Zerbetto Masson   RA: 15166804
 *		Matheus Manganeli de Macedo   RA: 16250276
 *		Rodrigo da Silva Cardoso      RA: 16430126
 *
 *	 Biblioteca de Recursos Comuns
 */

#pragma GCC diagnostic ignored "-Wunused-variable"
#pragma GCC diagnostic ignored "-Wunused-function"


#ifndef _COMMON_H
#define _COMMON_H

// #define DEBUG

#define DEVICE_NAME     "Modified_Minix"
#define KEY_LENGHT      16

#include <asm/atomic.h>
#include <linux/cdev.h>
#include <linux/crypto.h>
#include <linux/delay.h>
#include <linux/device.h>
#include <linux/errno.h>
#include <crypto/internal/hash.h>
#include <linux/init.h>
#include <asm/io.h>
#include <asm/irq.h>
#include <linux/irq.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/poll.h>
#include <linux/scatterlist.h>
#include <asm/uaccess.h>
#include <linux/types.h>
#include <linux/vmalloc.h>

/*
 * Global Variables
 */
#ifdef    __MASTER
  char          *key="01234567890123456789012345678912";
  unsigned char  keyHex[KEY_LENGHT];

  EXPORT_SYMBOL(key);
  EXPORT_SYMBOL(keyHex);
#endif

#ifndef   __MASTER
  extern char *key;
  extern unsigned char keyHex[KEY_LENGHT];
#endif

/*
 *  Functions
 */
ssize_t		custom_read_iter  (	struct kiocb * iocb,	struct iov_iter * iter);
ssize_t   custom_write_iter (	struct kiocb * iocb,	struct iov_iter * from);


/*
 *  AuxiliaryFunctions
 */
int     encrypt     ( u8 *, char *, char *, size_t );
int     decrypt     ( u8 *, char *, char *, size_t );

void    serialize   ( char *, char  *,  int    );
void    deserialize ( char *, char  *,  int    );
int     arrangeText ( char *, char **,  int    );
void    printHex    ( char *, int    ,  char * );
int     validate    ( char *, char **,  int    );

#endif
