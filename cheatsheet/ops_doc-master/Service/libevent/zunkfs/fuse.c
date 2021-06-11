
#define FUSE_USE_VERSION	26
#define _GNU_SOURCE

#include <assert.h>
#include <stdlib.h>
#include <fuse.h>
#include <fuse_opt.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <unistd.h>
#include <limits.h>
#include <dirent.h>
#include <pthread.h>
#include <ctype.h>
#include <stdarg.h>
#include <pthread.h>
#include <sys/mman.h>
#include <libgen.h>

#include "zunkfs.h"
#include "chunk-db.h"
#include "utils.h"
#include "dir.h"
#include "file.h"

#ifndef BLOCK_SIZE
#define BLOCK_SIZE 512
#endif

#ifndef CHUNK_BLOCKS
#define CHUNK_BLOCKS (CHUNK_SIZE / BLOCK_SIZE)
#endif

static int zunkfs_calc_size (struct dentry *dentry, void *data) {
    struct statvfs *stbuf = data;

    if (S_ISREG (dentry->mode))
        stbuf->f_files++;

    stbuf->f_blocks += (uint64_t) dentry_chunk_count (dentry) * CHUNK_BLOCKS;

    if (S_ISREG (dentry->mode))
        return 0;

    return scan_dir (dentry, zunkfs_calc_size, data);
}

static int zunkfs_statfs (const char *path, struct statvfs *stbuf) {
    struct dentry *dentry;
    int error;

    TRACE ("%s\n", path);

    /*
     * This is a bit painful, as there's no size information
     * in the root dentry, nor is there a superblock to record
     * total size. So instead, we need to iterate the entire FS
     * and calculate the size of each dentry.
     */

    dentry = find_dentry (path, NULL);
    if (IS_ERR (dentry))
        return -PTR_ERR (dentry);
    if (!S_ISDIR (dentry->mode)) {
        put_dentry (dentry);
        return -ENOTDIR;
    }

    memset (stbuf, 0, sizeof (struct statvfs));

    stbuf->f_bsize = BLOCK_SIZE;
    stbuf->f_blocks = 2 * CHUNK_BLOCKS; /* root's data & secret chunks */
    stbuf->f_bfree = ~0UL;
    stbuf->f_bavail = ~0UL;
    stbuf->f_files = 0;
    stbuf->f_ffree = ~0UL;
    stbuf->f_namemax = DDENT_NAME_MAX;

    error = scan_dir (dentry, zunkfs_calc_size, stbuf);
    put_dentry (dentry);

    return error;
}

static int zunkfs_getattr (const char *path, struct stat *stbuf) {
    struct dentry *dentry;
    int dir_as_file = 0;

    TRACE ("%s\n", path);

    dentry = find_dentry (path, &dir_as_file);
    if (IS_ERR (dentry))
        return -PTR_ERR (dentry);

    memset (stbuf, 0, sizeof (struct stat));

    lock (&dentry->mutex);

    /*
     * secret_digest does not change during the lifetime
     * of a dentry, and it's supposed to be random.
     * Hopefully that's good enough to generate a unique
     * inode number.
     */
    memcpy (&stbuf->st_ino, dentry->ddent->secret_digest, sizeof (ino_t));

    stbuf->st_mode = dentry->mode;

    /* hardlinks aren't supported */
    stbuf->st_nlink = 1;

    /* same for different users and groups */
    stbuf->st_uid = getuid ();
    stbuf->st_gid = getgid ();

    stbuf->st_size = dentry->size;

    stbuf->st_atime = dentry->mtime.tv_sec;
    stbuf->st_mtime = dentry->mtime.tv_sec;
    stbuf->st_ctime = le32toh (dentry->ddent->ctime);

    stbuf->st_blksize = 4096;
    stbuf->st_blocks = (dentry->size + 4095) / 4096;

    /* directory should really be treated as a file... */
    if (dir_as_file) {
        stbuf->st_mode &= ~S_IFDIR;
        stbuf->st_mode |= S_IFREG;
        stbuf->st_size *= sizeof (struct disk_dentry);
    }

    unlock (&dentry->mutex);
    put_dentry (dentry);

    return 0;
}

struct filldir_data {
    fuse_fill_dir_t func;
    void *buf;
};

static int zunkfs_filldir (struct dentry *dentry, void *data) {
    struct filldir_data *fdd = data;

    if (fdd->func (fdd->buf, (char *) dentry->ddent->name, NULL, 0))
        return -ENOBUFS;

    return 0;
}

static int zunkfs_readdir (const char *path, void *filldir_buf, fuse_fill_dir_t filldir, off_t offset, struct fuse_file_info *fuse_file) {
    struct filldir_data fdd;
    struct dentry *dentry;
    int err;

    TRACE ("path=%s offset=%llu\n", path, offset);

    if (offset)
        return -EINVAL;

    dentry = find_dentry (path, NULL);
    if (IS_ERR (dentry))
        return -PTR_ERR (dentry);

    err = -ENOTDIR;
    if (!S_ISDIR (dentry->mode))
        goto out;

    err = -ENOBUFS;
    if (filldir (filldir_buf, ".", NULL, 0) || filldir (filldir_buf, "..", NULL, 0))
        goto out;

    fdd.func = filldir;
    fdd.buf = filldir_buf;

    err = scan_dir (dentry, zunkfs_filldir, &fdd);
  out:
    put_dentry (dentry);
    return err;
}

static int zunkfs_open (const char *path, struct fuse_file_info *fuse_file) {
    struct open_file *ofile;

    TRACE ("%s\n", path);

    ofile = open_file (path);
    if (IS_ERR (ofile))
        return -PTR_ERR (ofile);

    fuse_file->fh = (uint64_t) (uintptr_t) ofile;

    return 0;
}

static int zunkfs_read (const char *path, char *buf, size_t bufsz, off_t offset, struct fuse_file_info *fuse_file) {
    struct open_file *ofile;

    TRACE ("path=%p bufsz=%zd offset=%zd\n", path, bufsz, offset);

    ofile = (struct open_file *) (uintptr_t) fuse_file->fh;
    if (!ofile)
        return -EINVAL;

    return read_file (ofile, buf, bufsz, offset);
}

static int zunkfs_write (const char *path, const char *buf, size_t bufsz, off_t offset, struct fuse_file_info *fuse_file) {
    struct open_file *ofile;

    TRACE ("path=%p bufsz=%zd offset=%zd\n", path, bufsz, offset);

    ofile = (struct open_file *) (uintptr_t) fuse_file->fh;
    if (!ofile)
        return -EINVAL;

    return write_file (ofile, buf, bufsz, offset);
}

static int zunkfs_release (const char *path, struct fuse_file_info *fuse_file) {
    struct open_file *ofile;

    TRACE ("%s\n", path);

    ofile = (struct open_file *) (uintptr_t) fuse_file->fh;
    if (!ofile)
        return -EINVAL;

    fuse_file->fh = 0;
    return close_file (ofile);
}

static int zunkfs_mkdir (const char *path, mode_t mode) {
    struct dentry *dentry;

    TRACE ("%s %o\n", path, mode);

    dentry = create_dentry (path, mode | S_IFDIR);
    if (IS_ERR (dentry))
        return -PTR_ERR (dentry);
    put_dentry (dentry);
    return 0;
}

static int zunkfs_create (const char *path, mode_t mode, struct fuse_file_info *fuse_file) {
    struct open_file *ofile;

    TRACE ("%s mode=%o\n", path, mode);

    ofile = create_file (path, mode);
    if (IS_ERR (ofile))
        return -PTR_ERR (ofile);

    if (fuse_file)
        fuse_file->fh = (uint64_t) (uintptr_t) ofile;
    else
        close_file (ofile);

    return 0;
}

static int zunkfs_flush (const char *path, struct fuse_file_info *fuse_file) {
    struct open_file *ofile;

    TRACE ("%s\n", path);

    ofile = (struct open_file *) (uintptr_t) fuse_file->fh;
    if (!ofile)
        return -EINVAL;

    return flush_file (ofile);
}

static int zunkfs_unlink (const char *path) {
    struct dentry *dentry;
    int err;

    TRACE ("%s\n", path);

    dentry = find_dentry (path, NULL);
    err = -PTR_ERR (dentry);
    if (!IS_ERR (dentry)) {
        err = del_dentry (dentry);
        put_dentry (dentry);
    }

    return err;
}

static int zunkfs_rmdir (const char *path) {
    struct dentry *dentry;
    int err;

    TRACE ("%s\n", path);

    dentry = find_dentry (path, NULL);
    if (IS_ERR (dentry))
        return -PTR_ERR (dentry);

    err = -ENOTDIR;
    if (!S_ISDIR (dentry->mode))
        goto out;

    err = -EBUSY;
    if (dentry->size)
        goto out;

    err = del_dentry (dentry);
  out:
    put_dentry (dentry);
    return err;
}

static int zunkfs_utimens (const char *path, const struct timespec tv[2]) {
    struct dentry *dentry;

    TRACE ("%s\n", path);

    dentry = find_dentry (path, NULL);
    if (IS_ERR (dentry))
        return -PTR_ERR (dentry);

    lock (&dentry->mutex);
    dentry->mtime.tv_sec = tv[1].tv_sec;
    dentry->mtime.tv_usec = tv[1].tv_nsec / 1000;
    dentry->dirty = 1;
    unlock (&dentry->mutex);

    put_dentry (dentry);

    return 0;
}

static int zunkfs_rename (const char *src, const char *dst) {
    struct dentry *dentry;
    struct dentry *dst_parent;
    int err;

    dentry = find_dentry_parent (dst, &dst_parent, &dst);
    if (IS_ERR (dentry))
        return -PTR_ERR (dentry);

    err = -EEXIST;
    if (dentry)
        goto out;

    dentry = find_dentry (src, NULL);
    if (IS_ERR (dentry)) {
        err = -PTR_ERR (dentry);
        goto out;
    }

    err = rename_dentry (dentry, dst, dst_parent);
    put_dentry (dentry);
  out:
    put_dentry (dst_parent);
    return err;
}

static int zunkfs_chmod (const char *path, mode_t mode) {
    struct dentry *dentry;

    if ((mode & S_IFMT) != 0)
        return -EINVAL;

    dentry = find_dentry (path, NULL);
    if (IS_ERR (dentry))
        return -PTR_ERR (dentry);

    dentry_chmod (dentry, mode & ~S_IFMT);
    put_dentry (dentry);

    return 0;
}

static struct fuse_operations zunkfs_operations = {
    .statfs = zunkfs_statfs,
    .getattr = zunkfs_getattr,
    .readdir = zunkfs_readdir,
    .open = zunkfs_open,
    .read = zunkfs_read,
    .write = zunkfs_write,
    .release = zunkfs_release,
    .mkdir = zunkfs_mkdir,
    .create = zunkfs_create,
    .flush = zunkfs_flush,
    .unlink = zunkfs_unlink,
    .utimens = zunkfs_utimens,
    .rmdir = zunkfs_rmdir,
    .rename = zunkfs_rename,
    .chmod = zunkfs_chmod
};

static void set_root_file (const char *fs_descr) {
    static DECLARE_MUTEX (root_mutex);
    struct disk_dentry *root_ddent;
    struct timeval now;
    int err, fd;

    fd = open (fs_descr, O_RDWR | O_CREAT, 0600);
    if (fd < 0) {
        ERROR ("open(%s): %s\n", fs_descr, strerror (errno));
        exit (-1);
    }

    root_ddent = mmap (NULL, 4096, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
    if (root_ddent == MAP_FAILED) {
        ERROR ("mmap(%s): %s\n", fs_descr, strerror (errno));
        exit (-2);
    }

    if (root_ddent->name[0] == '\0') {
        namcpy (root_ddent->name, "/");

        gettimeofday (&now, NULL);

        root_ddent->mode = htole16 (S_IFDIR | S_IRWXU);
        root_ddent->size = htole64 (0);
        root_ddent->ctime = htole32 (now.tv_sec);
        root_ddent->mtime = htole32 (now.tv_sec);
        root_ddent->mtime_csec = now.tv_usec / 10000;

        err = random_chunk_digest (root_ddent->secret_digest);
        if (err < 0) {
            ERROR ("random_chunk_digest: %s\n", strerror (-err));
            exit (-3);
        }

        memcpy (root_ddent->digest, root_ddent->secret_digest, CHUNK_DIGEST_LEN);
    } else if (root_ddent->name[0] != '/' || root_ddent->name[1]) {
        ERROR ("Bad superblock.\n");
        exit (-4);
    }

    err = set_root (root_ddent, &root_mutex);
    if (err) {
        ERROR ("Failed to set root: %s\n", strerror (-err));
        exit (-5);
    }
}

enum {
    OPT_HELP,
    OPT_LOG,
    OPT_CHUNK_DB
};

static struct fuse_opt zunkfs_opts[] = {
    FUSE_OPT_KEY ("--help", OPT_HELP),
    FUSE_OPT_KEY ("-h", OPT_HELP),
    FUSE_OPT_KEY ("--log=%s", OPT_LOG),
    FUSE_OPT_KEY ("--chunk-db=%s", OPT_CHUNK_DB),
    FUSE_OPT_END
};

static const char *prog = NULL;

static void usage (void) {
    /* FIXME: Need to play nicely with FUSE's --help. */
    fprintf (stderr,
             "usage: %s [options] root_ddent mountpt [mount options]\n"
             "zunkfs options:\n"
             "   --log=[level,]<file>     Log zunkfs events. Level is one of (E)rror,\n"
             "                            (W)arning, or (T)race. File can be a file,\n"
             "                            stdout, or stderr.\n"
             "   --chunk-db=<mode>,<spec> Add chunk storage. Mode is either ro or rw.\n"
             "                            rw can be followed by wt and/or nc. When writing,\n"
             "                            zunkfs will stop at the first writable db, unless\n"
             "                            the db is marked as write-through (wt). A read\n"
             "                            satisfied by chunkdb N will be cached by chunkdbs\n"
             "                            1...N-1 that are not marked as non-cachable (nc).\n"
             "                            Examples: \n"
             "                               --chunk-db=ro,dir:/foo\n" "                               --chunk-db=rw,wt,nc,mem=1000\n" "\n" "Available chunk databases:\n", prog);
    help_chunkdb ();
    fprintf (stderr, "\n");
}

static int opt_proc (void *data, const char *arg, int key, struct fuse_args *args) {
    static unsigned root_set = 0;
    char *errstr;
    int err;

    switch (key) {
    case OPT_HELP:
        usage ();
        if (fuse_opt_insert_arg (args, 1, "-ho"))
            return -1;
        return 0;
    case OPT_LOG:
        err = set_logging (arg + 6);
        if (err) {
            fprintf (stderr, "Failed to enable logging: %s\n", strerror (-err));
            return -1;
        }
        return 0;
    case OPT_CHUNK_DB:
        arg += 11;
        errstr = add_chunkdb (arg);
        if (errstr) {
            fprintf (stderr, "Failed to add chunkdb \"%s\": %s\n", arg, STR_OR_ERROR (errstr));
            return -1;
        }
        return 0;
    default:
        if (arg[0] == '-' || root_set)
            return 1;
        set_root_file (arg);
        root_set = 1;
        return 0;
    }
}

int main (int argc, char **argv) {
    struct fuse_args args = FUSE_ARGS_INIT (argc, argv);
    int err;

    prog = basename (argv[0]);

    if (fuse_opt_parse (&args, NULL, zunkfs_opts, opt_proc)) {
        return -1;
    }

    err = fuse_main (args.argc, args.argv, &zunkfs_operations, NULL);
    if (!err)
        flush_root ();

    return err;
}
