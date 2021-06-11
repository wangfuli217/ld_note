#ifndef __ZUNKFS_FILE_H__
#define __ZUNKFS_FILE_H__

#include "zunkfs.h"

struct dentry;
struct chunk_node;
struct open_file;

struct open_file *open_file (const char *path);
struct open_file *create_file (const char *path, mode_t mode);
int close_file (struct open_file *ofile);
int flush_file (struct open_file *ofile);
int read_file (struct open_file *ofile, char *buf, size_t bufsz, off_t offset);
int write_file (struct open_file *ofile, const char *buf, size_t len, off_t off);

struct dentry *file_dentry (struct open_file *ofile);

#endif
