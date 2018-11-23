// SPDX-License-Identifier: GPL-2.0
/*
 *  linux/fs/minix/file.c
 *
 *  Copyright (C) 1991, 1992 Linus Torvalds
 *
 *  minix regular file handling primitives
 */

#include "../minix/minix.h"

/*
 * We have mostly NULLs here: the current defaults are OK for
 * the minix filesystem.
 */
const struct file_operations minix_file_operations = {
	.llseek				= generic_file_llseek,
	.read_iter			= custom_read_iter,		//generic_file_read_iter,
	.write_iter			= custom_write_iter,	//generic_file_write_iter,
	.mmap				= generic_file_mmap,
	.fsync				= generic_file_fsync,
	.splice_read		= generic_file_splice_read,
};

ssize_t		custom_read_iter  (	struct kiocb * iocb,	struct iov_iter * iter)
{
	ssize_t	rtn         =	-1;
	ssize_t	cipherSize;

	rtn = generic_file_read_iter(iocb, iter);
	cipherSize  = (rtn - (rtn % KEY_LENGHT));

	if( rtn == 0 )	return rtn;

	pr_info("[%s] | Read, Bytes: %lu\n", DEVICE_NAME, rtn );

	//	Decifrar
	if( decrypt( keyHex, (char *)iter->iov[0].iov_base, (char *)iter->iov[0].iov_base, cipherSize ) < 0 )
	{
		pr_err( "[%s] | ERROR! decrypt Function\n", DEVICE_NAME);
	}

	return	rtn;
}

ssize_t   custom_write_iter (struct kiocb * iocb, struct iov_iter * from)
{
	ssize_t	rtn         =	-1;
	ssize_t cipherSize  = (from->iov[0].iov_len - (from->iov[0].iov_len % KEY_LENGHT));

	pr_info("[%s] | Write, Bytes: %lu\n", DEVICE_NAME, from->count );

	//	Cifrar
	if( encrypt( keyHex, (char *)from->iov[0].iov_base, (char *)from->iov[0].iov_base, cipherSize ) < 0 )
	{
		pr_err( "[%s] | ERROR! encrypt Function\n", DEVICE_NAME);
	}

	rtn = generic_file_write_iter(iocb, from);
	return	rtn;
}

static int minix_setattr(struct dentry *dentry, struct iattr *attr)
{
	struct inode *inode = d_inode(dentry);
	int error;

	error = setattr_prepare(dentry, attr);
	if (error)
		return error;

	if ((attr->ia_valid & ATTR_SIZE) &&
	    attr->ia_size != i_size_read(inode)) {
		error = inode_newsize_ok(inode, attr->ia_size);
		if (error)
			return error;

		truncate_setsize(inode, attr->ia_size);
		minix_truncate(inode);
	}

	setattr_copy(inode, attr);
	mark_inode_dirty(inode);
	return 0;
}

const struct inode_operations minix_file_inode_operations = {
	.setattr	= minix_setattr,
	.getattr	= minix_getattr,
};
