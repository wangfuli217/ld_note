---
title: 文件系统操作
comments: true
---

# 改变根文件系统

    int pivot_root(const char *new_root, const char *put_old);

# 文件系统属性

    struct statfs {
        __fsword_t f_type;    /* Type of filesystem (see below) */
        __fsword_t f_bsize;   /* Optimal transfer block size */
        fsblkcnt_t f_blocks;  /* Total data blocks in filesystem */
        fsblkcnt_t f_bfree;   /* Free blocks in filesystem */
        fsblkcnt_t f_bavail;  /* Free blocks available to
                                 unprivileged user */
        fsfilcnt_t f_files;   /* Total file nodes in filesystem */
        fsfilcnt_t f_ffree;   /* Free file nodes in filesystem */
        fsid_t     f_fsid;    /* Filesystem ID */
        __fsword_t f_namelen; /* Maximum length of filenames */
        __fsword_t f_frsize;  /* Fragment size (since Linux 2.6) */
        __fsword_t f_flags;   /* Mount flags of filesystem
                                 (since Linux 2.6.36) */
        __fsword_t f_spare[xxx];
                        /* Padding bytes reserved for future use */
    };

    #include <sys/vfs.h>    /* or <sys/statfs.h> */
    int statfs(const char *path, struct statfs *buf);
    int fstatfs(int fd, struct statfs *buf);

<!--more-->

# V文件系统属性

    struct statvfs {
        unsigned long  f_bsize;    /* Filesystem block size */
        unsigned long  f_frsize;   /* Fragment size */
        fsblkcnt_t     f_blocks;   /* Size of fs in f_frsize units */
        fsblkcnt_t     f_bfree;    /* Number of free blocks */
        fsblkcnt_t     f_bavail;   /* Number of free blocks for
                                      unprivileged users */
        fsfilcnt_t     f_files;    /* Number of inodes */
        fsfilcnt_t     f_ffree;    /* Number of free inodes */
        fsfilcnt_t     f_favail;   /* Number of free inodes for
                                      unprivileged users */
        unsigned long  f_fsid;     /* Filesystem ID */
        unsigned long  f_flag;     /* Mount flags */
        unsigned long  f_namemax;  /* Maximum filename length */
    };

    #include <sys/statvfs.h>
    int statvfs(const char *path, struct statvfs *buf);
    int fstatvfs(int fd, struct statvfs *buf);


# 磁盘提前读

ssize_t readahead(int fd, off64_t offset, size_t count);

# 挂载文件系统

int mount(const char *source, const char *target, const char *filesystemtype, unsigned long mountflags, const void *data);
#include <sys/mount.h>
int umount(const char *target);
int umount2(const char *target, int flags);

# 磁盘配额

    #include <sys/quota.h>
    #include <xfs/xqm.h> /* for XFS quotas */

    struct dqblk {      /* Definition since Linux 2.4.22 */
        uint64_t dqb_bhardlimit;  /* Absolute limit on disk
                                     quota blocks alloc */
        uint64_t dqb_bsoftlimit;  /* Preferred limit on
                                     disk quota blocks */
        uint64_t dqb_curspace;    /* Current occupied space
                                     (in bytes) */
        uint64_t dqb_ihardlimit;  /* Maximum number of
                                     allocated inodes */
        uint64_t dqb_isoftlimit;  /* Preferred inode limit */
        uint64_t dqb_curinodes;   /* Current number of
                                     allocated inodes */
        uint64_t dqb_btime;       /* Time limit for excessive
                                     disk use */
        uint64_t dqb_itime;       /* Time limit for excessive
                                     files */
        uint32_t dqb_valid;       /* Bit mask of QIF_*
                                     constants */
    };
    int quotactl(int cmd, const char *special, int id, caddr_t addr);
