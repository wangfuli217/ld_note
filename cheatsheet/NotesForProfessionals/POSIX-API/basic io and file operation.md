---
title: 基本IO和文件操作
comments: true
---

# tips

1. 当一个文件名刚好是最大长度时，可能无法判断原始名，因为可能被截断过

2. STDIN_FILENO、STDOUT_FILENO和STDERR_FILENO

3. stdin、stdout、stderr

4. restrict关键字

5. sysconf pathconf fpathconf

<!--more-->

# 目录操作

man 3 opendir

## dirent 结构体

    struct dirent
    {
    	long d_ino; /* inode number 索引节点号 */
    	off_t d_off; /* offset to this dirent 在目录文件中的偏移，和telldir相同*/
    	unsigned short d_reclen; /* length of this d_name 文件名长 */
    	unsigned char d_type; /* the type of d_name 文件类型 */
    	char d_name[NAME_MAX + 1]; /* file name (null-terminated) 文件名，最长255字符 */
    }
    d_type
    DT_BLK      This is a block device.
    DT_CHR      This is a character device.
    DT_DIR      This is a directory.
    DT_FIFO     This is a named pipe(FIFO).
    DT_LNK      This is a symbolic link.
    DT_REG      This is a regular file.
    DT_SOCK     This is a UNIX domain socket.
    DT_UNKNOWN  The file type could not be determined.

dirent指向特定目录项

## DIR结构体

    struct __dirstream
    {
      void *__fd; /* `struct hurd_fd' pointer for descriptor.   */
      char *__data; /* Directory block.   */
      int __entry_data; /* Entry number `__data' corresponds to.   */
      char *__ptr; /* Current pointer into the block.   */
      int __entry_ptr; /* Entry number `__ptr' corresponds to.   */
      size_t __allocation; /* Space allocated for the block.   */
      size_t __size; /* Total valid data in the block.   */
      __libc_lock_define (, __lock) /* Mutex lock for this structure.   */
    };
    typedef struct __dirstream DIR;

    struct linux_dirent {
      unsigned long  d_ino;     /* Inode number */
      unsigned long  d_off;     /* Offset to next linux_dirent */
      unsigned short d_reclen;  /* Length of this linux_dirent */
      char           d_name[];  /* Filename (null-terminated) */
                        /* length is actually (d_reclen - 2 -
                           offsetof(struct linux_dirent, d_name)) */
      /*
      char           pad;       // Zero padding byte
      char           d_type;    // File type (only since Linux
                                // 2.6.4); offset is (d_reclen - 1)
      */
    }

    struct linux_dirent64 {
      ino64_t        d_ino;    /* 64-bit inode number */
      off64_t        d_off;    /* 64-bit offset to next structure */
      unsigned short d_reclen; /* Size of this dirent */
      unsigned char  d_type;   /* File type */
      char           d_name[]; /* Filename (null-terminated) */
    };

DIR指向打开的DIR中的具体项

## opendir、fopendir、closedir、readdir、telldir、rewinddir、seekdir、rmdir、mkdir、mkdirat、scandir、scandirat、getdents、getdents64、readdir、readdir_r、dirfd

    #include <sys/types.h>
    #include <dirent.h>

    DIR *opendir(const char *name);
    DIR *fdopendir(int fd);
    int closedir(DIR *dirp);
    struct dirent *readdir(DIR *dirp);
    void rewinddir(DIR *dirp); //目录流偏移位置重置到初始位置
    long telldir(DIR *dirp);//返回目录流当前位置
    void seekdir(DIR *dirp, long loc);设置参数dir目录流目前的读取位置，在调用readdir()时便从此新位置开始读取

    int getdents(unsigned int fd, struct linux_dirent *dirp, unsigned int count);获取目录项
    int getdents64(unsigned int fd, struct linux_dirent64 *dirp, unsigned int count);

    struct old_linux_dirent {
      long  d_ino;              /* inode number */
      off_t d_off;              /* offset to this old_linux_dirent */
      unsigned short d_reclen;  /* length of this d_name */
      char  d_name[NAME_MAX+1]; /* filename (null-terminated) */
    };

    struct dirent {
      ino_t          d_ino;       /* Inode number */
      off_t          d_off;       /* Not an offset; see below */
      unsigned short d_reclen;    /* Length of this record */
      unsigned char  d_type;      /* Type of file; not supported
                                     by all filesystem types */
      char           d_name[256]; /* Null-terminated filename */
    };

    int readdir(unsigned int fd, struct old_linux_dirent *dirp, unsigned int count);
    struct dirent *readdir(DIR *dirp);
    int readdir_r(DIR *dirp, struct dirent *entry, struct dirent **result);

    int dirfd(DIR *dirp); 返回目录流dirp对应的文件描述符

    #include <unistd.h>
    int rmdir(const char *pathname);//可以删除空目录，一旦执行成功，则该目录下不能再创建文件，其它进程也不行

    #include <sys/stat.h>
    int mkdir(const char *pathname, mode_t mode);
    int mkdirat(int dirfd, const char *pathname, mode_t mode);
    如果pathname是绝对路径，忽略dirfd，如果是相对路径，且dirfd是AT_FDCWD，则相对当前路径，否则相对dirfd所指向的文件夹

    #include <dirent.h>
    int scandir(const char *dirp, struct dirent ***namelist, int (*filter)(const struct dirent *), int (*compar)(const struct dirent **, const struct dirent **));
    int alphasort(const struct dirent **a, const struct dirent **b);
    int versionsort(const struct dirent **a, const struct dirent **b);

    #include <fcntl.h>          /* Definition of AT_* constants */
    #include <dirent.h>
    int scandirat(int dirfd, const char *dirp, struct dirent ***namelist,
    int (*filter)(const struct dirent *),
    int (*compar)(const struct dirent **, const struct dirent **));

.和..自动创建，文件访问权限，pathname如果是绝对路径，忽略dirfd，如果是相对路径，并且dirfd置为AT_FDCWD，则pathname相对当前路径，否则相对dirfd指向的目录。

scandir扫描dirp所指向文件夹，dirp如果是相对路径，是相对当前工作目录，满足filter过滤函数的目录项放在namelist中，返回结果由compare函数排序，namelist由scandir申请，需要自己释放。

scandirat如果dirp绝对路径忽略dirfd，如果是相对路径，dirfd是AT_FDCWD则相对当前工作目录，否则相对dirfd。

alphasort根据dirent->d_name用strcoll比较

versionsort根据dirent->d_name用strverscmp比较

## 判断目录或者文件是否满足pattern， fnmatch

    int fnmatch(const char *pattern, const char *string, int flags);

判断目录或者文件是否满足pattern

## 目录树递归遍历，nftw、 ftw

    struct FTW {
        int base;
        int level;
    };

    #include <ftw.h>

    int nftw(const char *dirpath, int (*fn) (const char *fpath, const struct stat *sb, int typeflag, struct FTW *ftwbuf), int nopenfd, int flags);

    int ftw(const char *dirpath, int (*fn) (const char *fpath, const struct stat *sb, int typeflag), int nopenfd);

目录树前序遍历，目录优先。对每个目录项和子目录项递归调用fn。

## 目录遍历，非递归， fts

    typedef struct _ftsent {
        unsigned short  fts_info;     /* flags for FTSENT structure */
        char           *fts_accpath;  /* access path */
        char           *fts_path;     /* root path */
        short           fts_pathlen;  /* strlen(fts_path) */
        char           *fts_name;     /* filename */
        short           fts_namelen;  /* strlen(fts_name) */
        short           fts_level;    /* depth (-1 to N) */
        int             fts_errno;    /* file errno */
        long            fts_number;   /* local numeric value */
        void           *fts_pointer;  /* local address value */
        struct _ftsent *fts_parent;   /* parent directory */
        struct _ftsent *fts_link;     /* next file structure */
        struct _ftsent *fts_cycle;    /* cycle structure */
        struct stat    *fts_statp;    /* stat(2) information */
    } FTSENT;

    #include <sys/types.h>
    #include <sys/stat.h>
    #include <fts.h>

    FTS *fts_open(char * const *path_argv, int options, int (*compar)(const FTSENT **, const FTSENT **));
    FTSENT *fts_read(FTS *ftsp);
    FTSENT *fts_children(FTS *ftsp, int instr);
    int fts_set(FTS *ftsp, FTSENT *f, int instr);
    int fts_close(FTS *ftsp);

目录遍历，非递归方式

### 目录操作例子

    #include<sys/types.h>
    #include<dirent.h>
    #include<unistd.h>
    main()
    {
    	DIR * dir;
    	struct dirent * ptr;
    	int offset, offset_5, i = 0;
    	dir = opendir(“ / etc / rc.d”);
    	while ((ptr = readdir(dir)) != NULL)
    	{
    		if ((0 == strncasecmp(dirp->d_name, ".", 1)) || (0 != strcmp(strchr(dirp->d_name, '.'), ".txt"))) {
    			continue;
    			//忽略本目录和父目录，并过滤.txt结尾的文件
    		}
    		offset = telldir(dir);
    		if (++i == 5) offset_5 = offset;
    		printf(“d_name :%s offset : %d \n”, ptr->d_name, offset);
    	}
    	seekdir(dir, offset_5);
    	printf(“Readdir again!\n”);
    	while ((ptr = readdir(dir)) != NULL)
    	{
    		offset = telldir(dir);
    		printf(“d_name :%s offset : %d\n”, ptr->d_name.offset);
    	}
    	rewinddir(dir);
    	offset = telldir(dir);
    	printf(“d_name :%s offset : %d\n”, ptr->d_name.offset);
    	closedir(dir);
    }

### 目录读取例子

    #define _DEFAULT_SOURCE
    #include <dirent.h>
    #include <stdio.h>
    #include <stdlib.h>

    int
    main(void)
    {
    	struct dirent **namelist;
    	int n;

    	n = scandir(".", &namelist, NULL, alphasort);
    	if (n == -1) {
    		perror("scandir");
    		exit(EXIT_FAILURE);
    	}

    	while (n--) {
    		printf("%s\n", namelist[n]->d_name);
    		free(namelist[n]);
    	}
    	free(namelist);
    	exit(EXIT_SUCCESS);
    }

### 目录递归遍历

    #include "apue.h"
    #include <dirent.h>
    #include <limits.h>

    /* function type that is called for each filename */
    typedef	int	Myfunc(const char *, const struct stat *, int);

    static Myfunc	myfunc;
    static int		myftw(char *, Myfunc *);
    static int		dopath(Myfunc *);

    static long	nreg, ndir, nblk, nchr, nfifo, nslink, nsock, ntot;

    int
    main(int argc, char *argv[])
    {
    	int		ret;

    	if (argc != 2)
    		err_quit("usage:  ftw  <starting-pathname>");

    	ret = myftw(argv[1], myfunc);		/* does it all */

    	ntot = nreg + ndir + nblk + nchr + nfifo + nslink + nsock;
    	if (ntot == 0)
    		ntot = 1;		/* avoid divide by 0; print 0 for all counts */
    	printf("regular files  = %7ld, %5.2f %%\n", nreg,
    		nreg*100.0 / ntot);
    	printf("directories    = %7ld, %5.2f %%\n", ndir,
    		ndir*100.0 / ntot);
    	printf("block special  = %7ld, %5.2f %%\n", nblk,
    		nblk*100.0 / ntot);
    	printf("char special   = %7ld, %5.2f %%\n", nchr,
    		nchr*100.0 / ntot);
    	printf("FIFOs          = %7ld, %5.2f %%\n", nfifo,
    		nfifo*100.0 / ntot);
    	printf("symbolic links = %7ld, %5.2f %%\n", nslink,
    		nslink*100.0 / ntot);
    	printf("sockets        = %7ld, %5.2f %%\n", nsock,
    		nsock*100.0 / ntot);
    	exit(ret);
    }

    /*
    * Descend through the hierarchy, starting at "pathname".
    * The caller's func() is called for every file.
    */
    #define	FTW_F	1		/* file other than directory */
    #define	FTW_D	2		/* directory */
    #define	FTW_DNR	3		/* directory that can't be read */
    #define	FTW_NS	4		/* file that we can't stat */

    static char	*fullpath;		/* contains full pathname for every file */
    static size_t pathlen;

    static int					/* we return whatever func() returns */
    myftw(char *pathname, Myfunc *func)
    {
    	fullpath = path_alloc(&pathlen);	/* malloc PATH_MAX+1 bytes */
    										/* ({Prog pathalloc}) */
    	if (pathlen <= strlen(pathname)) {
    		pathlen = strlen(pathname) * 2;
    		if ((fullpath = realloc(fullpath, pathlen)) == NULL)
    			err_sys("realloc failed");
    	}
    	strcpy(fullpath, pathname);
    	return(dopath(func));
    }

    /*
    * Descend through the hierarchy, starting at "fullpath".
    * If "fullpath" is anything other than a directory, we lstat() it,
    * call func(), and return.  For a directory, we call ourself
    * recursively for each name in the directory.
    */
    static int					/* we return whatever func() returns */
    dopath(Myfunc* func)
    {
    	struct stat		statbuf;
    	struct dirent	*dirp;
    	DIR				*dp;
    	int				ret, n;

    	if (lstat(fullpath, &statbuf) < 0)	/* stat error */
    		return(func(fullpath, &statbuf, FTW_NS));
    	if (S_ISDIR(statbuf.st_mode) == 0)	/* not a directory */
    		return(func(fullpath, &statbuf, FTW_F));

    	/*
    	* It's a directory.  First call func() for the directory,
    	* then process each filename in the directory.
    	*/
    	if ((ret = func(fullpath, &statbuf, FTW_D)) != 0)
    		return(ret);

    	n = strlen(fullpath);
    	if (n + NAME_MAX + 2 > pathlen) {	/* expand path buffer */
    		pathlen *= 2;
    		if ((fullpath = realloc(fullpath, pathlen)) == NULL)
    			err_sys("realloc failed");
    	}
    	fullpath[n++] = '/';
    	fullpath[n] = 0;

    	if ((dp = opendir(fullpath)) == NULL)	/* can't read directory */
    		return(func(fullpath, &statbuf, FTW_DNR));

    	while ((dirp = readdir(dp)) != NULL) {
    		if (strcmp(dirp->d_name, ".") == 0 ||
    			strcmp(dirp->d_name, "..") == 0)
    			continue;		/* ignore dot and dot-dot */
    		strcpy(&fullpath[n], dirp->d_name);	/* append name after "/" */
    		if ((ret = dopath(func)) != 0)		/* recursive */
    			break;	/* time to leave */
    	}
    	fullpath[n - 1] = 0;	/* erase everything from slash onward */

    	if (closedir(dp) < 0)
    		err_ret("can't close directory %s", fullpath);
    	return(ret);
    }

    static int
    myfunc(const char *pathname, const struct stat *statptr, int type)
    {
    	switch (type) {
    	case FTW_F:
    		switch (statptr->st_mode & S_IFMT) {
    		case S_IFREG:	nreg++;		break;
    		case S_IFBLK:	nblk++;		break;
    		case S_IFCHR:	nchr++;		break;
    		case S_IFIFO:	nfifo++;	break;
    		case S_IFLNK:	nslink++;	break;
    		case S_IFSOCK:	nsock++;	break;
    		case S_IFDIR:	/* directories should have type = FTW_D */
    			err_dump("for S_IFDIR for %s", pathname);
    		}
    		break;
    	case FTW_D:
    		ndir++;
    		break;
    	case FTW_DNR:
    		err_ret("can't read directory %s", pathname);
    		break;
    	case FTW_NS:
    		err_ret("stat error for %s", pathname);
    		break;
    	default:
    		err_dump("unknown type %d for pathname %s", type, pathname);
    	}
    	return(0);
    }

## 工作路径设置函数

    #include <unistd.h>
    int chdir(const char *pathname);//如果是符号链接，则指向符号链接所指文件夹
    int fchdir(int fd);
    int *getcwd(char *buf, size_t size)
    char *getwd(char *buf);
    char *get_current_dir_name(void);

## 改变root路径

    int chroot(const char *path);

改变进程的根目录

## 改变根文件系统

    int pivot_root(const char *new_root, const char *put_old);

针对进程而言

# 文件操作

## inode硬链接操作，link、linkat、unlink、unlinkat

    #include <unistd.h>
    int link(const char *oldpath, const char *newpath);
    #include <fcntl.h>           /* Definition of AT_* constants */
    #include <unistd.h>
    int linkat(int olddirfd, const char *oldpath, int newdirfd, const char *newpath, int flags);

创建一个新目录项，指向已有文件

linkat， 如果path是相对路径，则相对应dirfd指向的文件夹，但是如果对应的dirfd值为AT_FDCWD，则相对当前工作目录。如果flags设置了AT_SYMLINK_FOLLOW标志，就创建符号链接所指向的实际文件链接。不允许指向目录的硬链接，

    #include <unistd.h>
    int unlink(const char *pathname);//只能删除文件，如果指向符号链接，删除符号链接本身。
    #include <fcntl.h>           /* Definition of AT_* constants */
    #include <unistd.h>
    int unlinkat(int dirfd, const char *pathname, int flags);

删除一个现有目录项，必须有包含该目录项目录的写和执行权限。如果该目录设置了粘着位，还需要下面三个条件之一：

* 拥有该文件
* 拥有该目录
* 具有超级用户权限

链接计数达到0时才会删除文件，如果有进程打开了该文件，其内容也不能被删除。关闭文件时，内核首先检查打开该文件的进程数目，如果计数达到0，再去检查链接计数。

对于unlinkat如果dirfd为AT_FDCWD，则当pathname为相对路径时，相对当前工作目录，否则相对dirfd指向目录，如果是绝对路径忽略dirfd。如果flags设置了AT_REMOVEDIR标志，unlinkat函数可以像rmdir一样删除目录。

进程open文件后，立刻调用unlink，可以创建一个临时文件，并且确保在进程退出时，文件被删除。

## 符号链接， symlink、symlinkat、readlink、readlinkat

不能有指向目录的硬链接，因为导致没法删除，inode计数问题。硬链接也必须位于同一文件系统内，

    #include <unistd.h>
    int symlink(const char *target, const char *linkpath);
    #include <fcntl.h>           /* Definition of AT_* constants */
    #include <unistd.h>
    int symlinkat(const char *target, int newdirfd, const char *linkpath);
    #include <unistd.h>
    ssize_t readlink(const char *pathname, char *buf, size_t bufsiz);
    #include <fcntl.h>           /* Definition of AT_* constants */
    #include <unistd.h>
    ssize_t readlinkat(int dirfd, const char *pathname, char *buf, size_t bufsiz);

target并不需要存在，symlinkat函数，如linkpath是绝对路径忽略dirfd,如果是相对路径，newdirfd指定了AT_FDCWD，则相对当前工作目录，否则相对newdirfd所指向文件夹

## 文件描述符复制

不同的进程打开同一个文件，则在不同进程有不同的文件描述符，在操作系统有不同的文件表项，但是指向系统的v节点。当前文件状态标志和当前文件偏移量存储在操作系统表项中。每次lseek到文件最后和使用O_APPEND操作是不同的，因为文件偏移量保存在操作系统表项中，而O_APPEND每次同步v节点的当前文件长度，O_APPEND具有数据一致性。

    #include <unistd.h>
    int dup(int oldfd);
    int dup2(int oldfd, int newfd);
    #define _GNU_SOURCE             /* See feature_test_macros(7) */
    #include <fcntl.h>              /* Obtain O_* constant definitions */
    #include <unistd.h>
    int dup3(int oldfd, int newfd, int flags);

dup系列函数是原子操作，共享系统文件表项，但是有自己的标志，newfd的FD_CLOSEXEC标志会被清除。

## 文件截断扩展， truncate、ftruncate

    #include <unistd.h>
    #include <sys/types.h>
    int truncate(const char *path, off_t length);
    int ftruncate(int fd, off_t length);

可以把文件放大

## 删除文件，remove

    #include <stdio.h>
    int remove (const char *pathname)；

对于文件等同于unlink，对于目录等同于rmdir

## 重命名文件 rename、renameat、renameat2

    #include <stdio.h>
    int rename(const char *oldpath, const char *newpath);
    #include <fcntl.h>           /* Definition of AT_* constants */
    #include <stdio.h>
    int renameat(int olddirfd, const char *oldpath, int newdirfd, const char *newpath);
    int renameat2(int olddirfd, const char *oldpath, int newdirfd, const char *newpath, unsigned int flags);

* 如果oldpath指向文件，则newpath不能指向目录，当newpath存在时，先删除，要求进程具有写权限，需要包含oldname和newname目录的写和执行权限。当为目录重命名时，oldname不能是newname的前缀。

* 若oldname指向符号链接，处理符号链接本身，而不是所指向文件

* 不能对.和..重命名

* oldnanme和newname相同，不做任何改变。

对于renameat，如果是绝对路径，忽略olddirfd或newdirfd，如果是相对路径，如果olddirfd或者newdirfd设置为AT_FDCWD，这相对当前工作目录，否则相对于olddirfd或者newdirfd所指向目录。

## 具有唯一名字的临时文件和目录

    char *tmpnam(char *s); //如果s为NULL，产生的与现有文件名不同的字符窜则放在静态区，地址作为函数返回值，不为NULL，则存放在s中，也作为函数返回值
    char *tmpnam_r(char *s);
    char *tempnam(const char *dir, const char *pfx);创建一个目前不存在相同名字文件的文件名，pfx是文件名前缀
    FILE *tmpfile(void); //创建一个临时二进制文件，一般是先调用tmpnam，然后unlink，原子操作
    char *mktemp(char *template);//产生一个临时唯一文件名

    #include <stdlib.h>
    char *mkdtemp(char *template);//创建一个具有唯一名字的目录
    int mkstemp(char *template);//创建一个文件，该文件具有唯一的名字，不会自动删除，原子操作
    int mkostemp(char *template, int flags);//创建一个文件，该文件具有唯一的名字，不会自动删除，原子操作，用flags指定文件模式
    int mkstemps(char *template, int suffixlen);同mkstemp，但是带文件前缀
    int mkostemps(char *template, int suffixlen, int flags);同mkostemp，但是带前缀

# 文件属性

## stat、fstat、lstat、fstatat

    struct stat {
    	dev_t     st_dev;         /* ID of device containing file */
    	ino_t     st_ino;         /* Inode number */
    	mode_t    st_mode;        /* File type and mode */
    	nlink_t   st_nlink;       /* Number of hard links */
    	uid_t     st_uid;         /* User ID of owner */
    	gid_t     st_gid;         /* Group ID of owner */
    	dev_t     st_rdev;        /* Device ID (if special file) */
    	off_t     st_size;        /* Total size, in bytes */
    	blksize_t st_blksize;     /* Block size for filesystem I/O */
    	blkcnt_t  st_blocks;      /* Number of 512B blocks allocated */

    							  /* Since Linux 2.6, the kernel supports nanosecond
    							  precision for the following timestamp fields.
    							  For the details before Linux 2.6, see NOTES. */

    	struct timespec st_atim;  /* Time of last access */
    	struct timespec st_mtim;  /* Time of last modification */
    	struct timespec st_ctim;  /* Time of last status change */

    #define st_atime st_atim.tv_sec      /* Backward compatibility */
    #define st_mtime st_mtim.tv_sec
    #define st_ctime st_ctim.tv_sec
    };

### 获取设备号

    #include "apue.h"
    #ifdef SOLARIS
    #include <sys/mkdev.h>
    #endif

    int
    main(int argc, char *argv[])
    {
    	int			i;
    	struct stat	buf;

    	for (i = 1; i < argc; i++) {
    		printf("%s: ", argv[i]);
    		if (stat(argv[i], &buf) < 0) {
    			err_ret("stat error");
    			continue;
    		}

    		printf("dev = %d/%d", major(buf.st_dev), minor(buf.st_dev));

    		if (S_ISCHR(buf.st_mode) || S_ISBLK(buf.st_mode)) {
    			printf(" (%s) rdev = %d/%d",
    				(S_ISCHR(buf.st_mode)) ? "character" : "block",
    				major(buf.st_rdev), minor(buf.st_rdev));
    		}
    		printf("\n");
    	}

    	exit(0);
    }

### 打印文件信息

    #include <sys/types.h>
    #include <sys/stat.h>
    #include <time.h>
    #include <stdio.h>
    #include <stdlib.h>
    #include <sys/sysmacros.h>

    int
    main(int argc, char *argv[])
    {
    	struct stat sb;

    	if (argc != 2) {
    		fprintf(stderr, "Usage: %s <pathname>\n", argv[0]);
    		exit(EXIT_FAILURE);
    	}

    	if (stat(argv[1], &sb) == -1) {
    		perror("stat");
    		exit(EXIT_FAILURE);
    	}

    	printf("ID of containing device:  [%lx,%lx]\n",
    		(long)major(sb.st_dev), (long)minor(sb.st_dev));

    	printf("File type:                ");

    	switch (sb.st_mode & S_IFMT) {
    	case S_IFBLK:  printf("block device\n");            break;
    	case S_IFCHR:  printf("character device\n");        break;
    	case S_IFDIR:  printf("directory\n");               break;
    	case S_IFIFO:  printf("FIFO/pipe\n");               break;
    	case S_IFLNK:  printf("symlink\n");                 break;
    	case S_IFREG:  printf("regular file\n");            break;
    	case S_IFSOCK: printf("socket\n");                  break;
    	default:       printf("unknown?\n");                break;
    	}

    	printf("I-node number:            %ld\n", (long)sb.st_ino);

    	printf("Mode:                     %lo (octal)\n",
    		(unsigned long)sb.st_mode);

    	printf("Link count:               %ld\n", (long)sb.st_nlink);
    	printf("Ownership:                UID=%ld   GID=%ld\n",
    		(long)sb.st_uid, (long)sb.st_gid);

    	printf("Preferred I/O block size: %ld bytes\n",
    		(long)sb.st_blksize);
    	printf("File size:                %lld bytes\n",
    		(long long)sb.st_size);
    	printf("Blocks allocated:         %lld\n",
    		(long long)sb.st_blocks);

    	printf("Last status change:       %s", ctime(&sb.st_ctime));
    	printf("Last file access:         %s", ctime(&sb.st_atime));
    	printf("Last file modification:   %s", ctime(&sb.st_mtime));

    	exit(EXIT_SUCCESS);
    }

## 扩展属性statx、

    #include <sys/types.h>
    #include <sys/stat.h>
    #include <unistd.h>
    int stat(const char *pathname, struct stat *statbuf);//如果是符号链接，会返回实际文件信息
    int fstat(int fd, struct stat *statbuf);//如果是符号链接，会返回实际文件信息
    int lstat(const char *pathname, struct stat *statbuf); //返回符号链接文件信息
    #include <fcntl.h>           /* Definition of AT_* constants */
    #include <sys/stat.h>
    int fstatat(int dirfd, const char *pathname, struct stat *statbuf, int flags);//相对于dirfd目录，如果flag设置了AT_SYMLINK_NOFOLLOW，返回符号链接文件信息，否则返回实际文件信息，如果dirfd设置为AT_FDCWD则相对于当前目录，忽略dirfd，如果是绝对路径，则直接使用绝对路径。如果pathname为空，则返回dirfd所指向文件信息，此时dirfd可以指向任意类型文件。AT_NO_AUTOMOUNT如果pathname base部分是自动挂载点，不会自动挂载，这样可以得到挂载点信息，

    struct statx_timestamp {
        __s64 tv_sec;    /* Seconds since the Epoch (UNIX time) */
        __u32 tv_nsec;   /* Nanoseconds since tv_sec */
    };

    struct statx {
      __u32 stx_mask;        /* Mask of bits indicating
                                filled fields */
      __u32 stx_blksize;     /* Block size for filesystem I/O */
      __u64 stx_attributes;  /* Extra file attribute indicators */
      __u32 stx_nlink;       /* Number of hard links */
      __u32 stx_uid;         /* User ID of owner */
      __u32 stx_gid;         /* Group ID of owner */
      __u16 stx_mode;        /* File type and mode */
      __u64 stx_ino;         /* Inode number */
      __u64 stx_size;        /* Total size in bytes */
      __u64 stx_blocks;      /* Number of 512B blocks allocated */
      __u64 stx_attributes_mask;
                             /* Mask to show what's supported
                                in stx_attributes */

      /* The following fields are file timestamps */
      struct statx_timestamp stx_atime;  /* Last access */
      struct statx_timestamp stx_btime;  /* Creation */
      struct statx_timestamp stx_ctime;  /* Last status change */
      struct statx_timestamp stx_mtime;  /* Last modification */

      /* If this file represents a device, then the next two
         fields contain the ID of the device */
      __u32 stx_rdev_major;  /* Major ID */
      __u32 stx_rdev_minor;  /* Minor ID */

      /* The next two fields contain the ID of the device
         containing the filesystem where the file resides */
      __u32 stx_dev_major;   /* Major ID */
      __u32 stx_dev_minor;   /* Minor ID */
    };

### 扩展的stat，用于获取文件状态， statx

    int statx(int dirfd, const char *pathname, int flags, unsigned int mask, struct statx *statxbuf);

### 获取扩展属性，getxattr、lgetxattr、fgetxattr

    ssize_t getxattr(const char *path, const char *name, void *value, size_t size);
    ssize_t lgetxattr(const char *path, const char *name, void *value, size_t size);
    ssize_t fgetxattr(int fd, const char *name, void *value, size_t size);

### 列出扩展属性，listxattr、llistxattr、flistxattr

    ssize_t listxattr(const char *path, char *list, size_t size);
    ssize_t llistxattr(const char *path, char *list, size_t size);
    ssize_t flistxattr(int fd, char *list, size_t size);

### 设置扩展属性，setxattr、lsetxattr、fsetxattr

    int setxattr(const char *path, const char *name, const void *value, size_t size, int flags);
    int lsetxattr(const char *path, const char *name, const void *value, size_t size, int flags);
    int fsetxattr(int fd, const char *name, const void *value, size_t size, int flags);

### 删除扩展属性，removexattr、lremovexattr、fremovexattr

    #include <sys/types.h>
    #include <sys/xattr.h>

    int removexattr(const char *path, const char *name);
    int lremovexattr(const char *path, const char *name);
    int fremovexattr(int fd, const char *name);

# 文件时间属性操作

## 文件时间类型

* st_atim 访问时间，read
* st_mtim 修改时间write
* st_ctim i节点修改时间 chmod， chown，link等，这个值是系统自动修改，不能由API修改

系统没有维护i节点最后的访问时间，因此access和stat函数不会改变这三个时间中任一一个。

## 修改文件的访问时间和修改时间，utimensat、futimens

    struct timespec {
    	time_t tv_sec;        /* seconds */
    	long   tv_nsec;       /* nanoseconds */
    };

    #include <fcntl.h> /* Definition of AT_* constants */
    #include <sys/stat.h>
    int utimensat(int dirfd, const char *pathname, const struct timespec times[2], int flags);
    int futimens(int fd, const struct timespec times[2]);
    int futimesat(int dirfd, const char *pathname, const struct timeval times[2]);过时了

* times参数为NULL，将访问时间和修改时间置为当前时间

* 如果times任一数组元素tv_nsec字段为UTIME_NOW，相应时间戳置为当前时间，忽略tv_sec字段，要求进程有效用户ID必须等于所有者ID，或者进程需要写权限，或者进程是超级权限进程

* 如果times任一数组元素tv_nsec字段为UTIME_OMIT，相应时间戳保持不变，忽略相应tv_sec字段，如果两个tv_nsec字段都为UTIME_OMIT，则不进行权限检查

* times两个元素tv_nsec字段既不是UTIME_NOW又不是UTIME_OMIT，则有效用户ID必须等于所有者ID

* utimensat pathname如果是绝对路径，忽略dirfd， 如果是相对路径，并且fd值为AT_FDCWD，则相对当前工作目录，否则相对fd所指向目录，
flags如果设置了AT_SYMLINK_NOFOLLOW标志，则修改符号链接文件本身参数，否则修改符号链接指向的实际文件

## 修改文件访问和修改时间，utime、utimes、futimes、lutimes

    struct timeval {
    	long tv_sec;        /* seconds */
    	long tv_usec;       /* microseconds */
    };

    struct utimbuf {
    	time_t actime;       /* access time */
    	time_t modtime;      /* modification time */
    };
    #include <sys/types.h>
    #include <utime.h>
    int utime(const char *filename, const struct utimbuf *times);
    #include <sys/time.h>
    int utimes(const char *filename, const struct timeval times[2]);
    #include <sys/time.h>
    int futimes(int fd, const struct timeval tv[2]);
    int lutimes(const char *filename, const struct timeval tv[2]);

修改文件访问和修改时间

# 文件权限

## 实际用户文件权限测试，access、faccessat

     #include <unistd.h>
     int access(const char *pathname, int mode);
     #include <fcntl.h>           /* Definition of AT_* constants */
     #include <unistd.h>
     int faccessat(int dirfd, const char *pathname, int mode, int flags);

 open函数以有效用户ID和有效组ID测试访问权限，access和faccess函数按实际用户ID，实际用户组ID进行访问权限测试。

 对于faccessat，pathname为绝对路径，忽略dirfd，如果是相对路径，并且值为AT_FDCWD，则相对当前工作目录，否则相对dirfd指向目录。
 flags设置为AT_EACCESS，则改用有效用户ID和有效组ID测试访问权限。

    S_ISUID  (04000)  set-user-ID (set process effective user ID on execve(2))
    S_ISGID  (02000)  set-group-ID (set process effective group ID on
                             execve(2); mandatory locking, as described in
                             fcntl(2); take a new file's group from parent
                             directory, as described in chown(2) and mkdir(2))

    S_ISVTX  (01000)  sticky bit (restricted deletion flag)
    S_IRWXU    所有者读、写和执行权限
    S_IRUSR  (00400)  read by owner
    S_IWUSR  (00200)  write by owner
    S_IXUSR  (00100)  execute/search by owner ("search" applies for
                             directories, and means that entries within the
                             directory can be accessed)
    S_IRWXG  组读、写和执行权限
    S_IRGRP  (00040)  read by group
    S_IWGRP  (00020)  write by group
    S_IXGRP  (00010)  execute/search by group
    S_IRWXO	其它读、写和执行权限
    S_IROTH  (00004)  read by others
    S_IWOTH  (00002)  write by others
    S_IXOTH  (00001)  execute/search by others

## 有效用户文件权限测试，euidaccess、eaccess

    int euidaccess(const char *pathname, int mode);
    int eaccess(const char *pathname, int mode);

检查有效用户文件权限

## umask、chmod、fchmod、fchmodat

    #include <sys/types.h>
    #include <sys/stat.h>
    mode_t umask(mode_t cmask);
    mode_t getumask(void);

    #include <sys/stat.h>
    int chmod(const char *pathname, mode_t mode);
    int fchmod(int fd, mode_t mode);
    #include <fcntl.h>           /* Definition of AT_* constants */
    #include <sys/stat.h>
    int fchmodat(int dirfd, const char *pathname, mode_t mode, int flags);

如果pathname是绝对路径，忽略dirfd，如果pathname是相对路径，并且值为AT_FDCWD则相对当前工作目录，否则相对dirfd

    int main(void)
    {
    	struct stat		statbuf;

    	/* turn on set-group-ID and turn off group-execute */

    	if (stat("foo", &statbuf) < 0)
    		err_sys("stat error for foo");
    	if (chmod("foo", (statbuf.st_mode & ~S_IXGRP) | S_ISGID) < 0)
    		err_sys("chmod error for foo");

    	/* set absolute mode to "rw-r--r--" */

    	if (chmod("bar", S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH) < 0)
    		err_sys("chmod error for bar");

    	exit(0);
    }

## chown、fchown、lchown、fchownat

    #include <unistd.h>
    int chown(const char *pathname, uid_t owner, gid_t group);
    int fchown(int fd, uid_t owner, gid_t group);
    int lchown(const char *pathname, uid_t owner, gid_t group);

    #include <fcntl.h>           /* Definition of AT_* constants */
    #include <unistd.h>
    int fchownat(int dirfd, const char *pathname, uid_t owner, gid_t group, int flags);

lchown和flags设置了AT_SYMLINK_NOFOLLOW的fchownat改变链接文件本身用户ID和用户组ID，，其它函数会修改符号链接文件实际指向的文件。fchownat如果pathname是绝对路径，忽略dirfd，如果是相对路径，并且dirfd为AT_FDCWD则相对当前工作目录，否则相对dirfd

若_POSIX_CHOWN_RESTARICTED对指定文件生效，则：

* 只有超级用户可以改变文件的用户ID

* 如果进程拥有该文件（有效用户ID等于该文件用户ID）则参数owner为-1或者文件用户ID，并且参数group等于进程有效组ID或者进程附属组ID之一，那么一个非超级用户进程可以更改该文件的组ID。

* 这些函数如果由非超级用户进程调用，成功返回时，SUID和SGID被清除。

# 文件同步守护进程控制

    #include <sys/kdaemon.h>
    int bdflush(int func, long *address);
    int bdflush(int func, long data);

启动或者洗刷脏缓冲或者更改脏缓冲冲洗守护进程

# 文件属性操作函数

## fcntl

    struct f_owner_ex {
    	int   type;
    	pid_t pid;
    };

    struct flock
    {
    	short l_type;/*F_RDLCK，读共享锁, F_WRLCK，写互斥锁, or F_UNLCK对一个区域解锁*/
    	off_t l_start;/*相对于l_whence的偏移值，字节为单位*/
    	short l_whence;/*从哪里开始：SEEK_SET, SEEK_CUR, or SEEK_END*/
    	off_t l_len;/*长度, 字节为单位; 0 意味着缩到文件结尾*/
    	pid_t l_pid;/*returned with F_GETLK*/
    };

    #include <unistd.h>
    #include <fcntl.h>
    int fcntl (int fd, int cmd, ...);

### 复制一个已有文件描述符

>F_DUPFD  指定第三个参数时，返回大于等于该参数值，复制后的描述符共享同一系统文件表项，但是有不同的标志FD_CLOEXEC标志被清除
>
>F_DUPFD_CLOEXEC 和F_DUPFD类似，但是复制FD_CLOEXEC

### 获取/设置文件描述符标志

>F_GETFD
>
>F_SETFD  设置为第三个参数

### 获取/设置文件状态标志

>F_GETFL   获取open打开文件时设置的flags，O_RDONLY,O_WRONLY, O_RDWR,O_EXEC,O_SEARCH这五个状态共同占用一个位，需要和O_ACCMODE配合确定是哪个标志
>
>F_SETFL   设置为第三个参数，会关闭原来的状态标志

### 获取/设置异步IO所有权

>F_GETOWN  获取当前接收SIGIO,SIGURG信号的进程ID或进程组ID，正数返回进程ID，为负时指定进程组ID
>
>F_SETOWN  设置接收SIGIO,SIGURG信号的进程，arg为正数指定进程，为负时指定进程组，需要fcntl F_SETFL命令设置O_ASYNC，需要权限，如果没有足够的权限，信号会被丢弃
>
>F_GETOWN_EX 获取线程的 //F_OWNER_TID
>
>F_SETOWN_EX 可以设置直接IO信号到指定线程，进程，进程组，分别由arg所指向的f_owner_ex type值为F_OWNER_TID，F_OWNER_PID，F_OWNER_PGRP（是正数）
>
>F_GETSIG 获取SIGIO是否已经发送，已经发送SIGIO通过第三个参数arg返回0，其它信号包括SIGIO返回其它值，返回其它值时可以获取SA_SIGINFO指定的额外信息
>
>F_SETSIG 当输入或者输出准备好时发送什么信号，arg指定为0发送默认的SIGIO，其它值发送其它信号，包括SIGIO，也就是改变了默认发送SIGIO这个信号行为，当是其它信号时，可以获取SA_SIGINFO指定的额外信息。当是其它值时，si_code显示是SIGIO，si_fd指出信号关联这个文件描述符，其它情况不能获取这个文件描述符。如果文件描述符是通过dup复制的，但是原先的fd被关闭，此时SIGIO发生时，si_fd指向原先那个被关闭的fd

### 租约

>当进程在文件上设置租约时，如果其它进程试图open或者truncate该文件时，此进程会得到通知，默认是SIGIO，租约和文件描述符相关，因此fork或者dup会获得相同的租约，因此在任一文件描述符上关闭或者显式关闭租约，其它关联文件描述符上的租约都会被关闭。
>
>F_GETLEASE 返回什么类型租约，F_UNLCK表示没有租约
>
>F_SETLEASE
>
>F_RDLCK 当其它进程写或者截断打开文件时，进程会得到通知，但是只读打开不会
>
>F_WRLCK 当其它进程读或写或截断打开文件时，进程会得到通知
>
>F_UNLCK 解除租约

如果进程B试图open或者truncate文件，违反进程A的租约，系统会阻塞B的系统调用，并默认用SIGIO通知A，A必须在/proc/sys/fs/lease-break-time规定的时间，完成清理工作，冲刷cache等，并移除租约或者降级到相容的租约级别。如果超时，系统会强制移除租约或者降级租约，一旦移除租约或者降级租约，系统会恢复B的调用。

B如果在等待过程被信号中断，在信号处理函数返回后，出错返回errno置为EINTR，A的步骤还是会继续，如果B设置了O_NONBLOCK，则立刻出错返回，errno置为EWOULDBLOCK，其它步骤继续。

通知信号可以使用fcntl F_SETSIG命令改变。

### File and directory change notification (dnotify)

* F_NOTIFY

    >当文件夹和文件夹下面任一文件改变时，arg指定那种情况改变时通知进程
    >
    >DN_ACCESS 文件被访问read, pread, readv
    >
    >DN_MODIFY 文件被修改write, pwrite，writev, truncate, ftruncate
    >
    >DN_CREATE 文件被创建open, creat, mknod,mkdir, link, symlink, rename
    >
    >DN_DELETE 文件被解除连接，unlink，rename，rmdir
    >
    >DN_RENAME 文件被重命名，rename
    >
    >DN_ATTRIB 文件属性改变，chown，chmod，utime，utimensat
    >
    >DN_MULTISHOT 持续通知
    >0 关闭通知

需测试_GNU_SOURCE宏，通知是一次性的，每次通知完后，需要重新调用fcntl来设置通知，除非指定DN_MULTISHOT，可以多次添加通知状态，这些状态会叠加。

默认使用SIGIO通知，SIGIO是非实时信号，可以用fcntl F_SETSIG命令改成实时信号。

### Changing the capacity of a pipe

* F_SETPIPE_SZ

    >改变fd指向的管道容量大小，非特权进程可以将管道大小设置为page大小和 /proc/sys/fs/pipe-max-size大小之间，小于page会上调到page大小，特权进程可以将管道大小设置到page和CAP_SYS_RESOURCE之间。设置超过授权大小将出错返回，errno置为EPERM。将管道大小设置为目前管道已存数据大小，将出错返回，errno置为EBUSY

* F_GETPIPE_SZ

    >获取管道容量大小

###  File Sealing

限制指定文件上的操作，被限制的操作会出错返回，errno置为EPERM，seal是inode属性，因此不同进程打开同一文件，seal相同。seal不能移除，只能增加。目前只适用于memfd_create返回的文件描述符。

* F_ADD_SEALS 添加seal set，如果set包括F_SEAL_SEAL，调用会出错返回，errno置为EPERM，因为这个设置是立刻生效的，注意F_SEAL_SEAL还是会设置成功，指向fd必须可写。

* F_SEAL_SEAL 将导致调用fcntl F_ADD_SEALS出错返回，errno置为EPERM

* F_SEAL_SHRINK 文件大小不能缩小，将导致open带O_TRUNC参数，以及truncate和ftruncate失败返回，errno置为EPERM

*	F_SEAL_GROW 文件不能增大，write超出文件末尾，truncate和ftruncate，fallocate失败返回，errno置为EPERM

*	F_SEAL_WRITE

  	>不能修改文件，缩小文件和扩大文件还是可以的。
    >
    >write和fallocate带上 FAL‐LOC_FL_PUNCH_HOLE标志会失败，errno置为EPERM，F_SEAL_WRITE设置后，调用mmap映射到内存也会失败。如果已经存在**可写**的共享内存存在，fctnl出错返回，errno置为EBUSY
    >
    >如果还有该文件还有未提交的异步IO操作，会被丢失

### File read/write hints

* F_GET_RW_HINT

    > 获取文件描述符所关联的inode读写提示

* F_SET_RW_HINT

    > 设置文件描述符所关联的inode读写提示

* F_GET_FILE_RW_HINT

    > 获取文件描述符的读写提示

* F_SET_FILE_RW_HINT

    > 设置文件描述符的读写提示

* RWH_WRITE_LIFE_NOT_SET

    > 没有指定读写提示，这个是默认值

* RWH_WRITE_LIFE_NONE

    > 文件描述符关联的inode没有指定写生命周期提示

* RWH_WRITE_LIFE_SHORT

    > 文件描述符所关联的inode希望写生命周期是短暂的

* RWH_WRITE_LIFE_MEDIUM

    > 文件描述符所关联的inode希望写生命周期是适当的

* RWH_WRITE_LIFE_LONG

    > 文件描述符所关联的inode希望写生命周期是较长的

* RWH_WRITE_LIFE_EXTREME

    > 文件描述符所关联的inode希望写生命周期是很长的

### 获取/设置记录锁

第三个指针参数指向flock参数

### Advisory record locking

* F_GETLK

* F_SETLK  设置锁或者释放锁，设置锁系统会检测死锁，如果发现死锁，出错返回errno位置EDEADLK

* F_SETLKW 对应着F_SETLK的可以阻塞的版本。w意味着wait，等待过程被信号中断，从信号处理函数返回后再返回-1，errno置为EINTR

> 锁可以开始或者超过文件当前结束位置，但是不可以开始或者超过文件的开始位置
>
> 如果l_len为0，意味着锁的区域为可以到达的最大文件偏移位置。这个类型，可以让我们锁住一个文件的任意开始位置，结束的区域可以到达任意的文件结尾，并且以append方式追加文件时，也会同样上锁
>
>如果要锁住整个文件，设置l_start 和 l_whence为文件的开始位置（l_start为0 l_whence 为 SEEK_SET ），并且l_len为0。
>
>如果有多个读共享锁(l_type of F_RDLCK),其他的读共享锁可以接受，但是写互斥锁(type ofF_WRLCK)拒绝
>
>如果有一个写互斥锁(type ofF_WRLCK),其他的读共享锁(l_type of F_RDLCK)拒绝，其他的写互斥锁拒绝。
>
>如果要取得读锁，这个文件描述符必须被打开可以去读；如果要或者写锁，这个文件的描述符必须可以被打开可以去写。
>
>进程终止后会释放所有锁
>
>锁不会被子进程继承
>
>标准IO因为使用了缓存，应该避免使用锁。使用不带缓存的IO
>
>关闭任何文件描述符会导致关联文件上的锁被释放，所以A进程会影响B进程
>
>线程之间共享记录锁

### Open file description locks

* 文件描述符锁和文件描述符相关联，而不是和进程。

* fork和clone后会继承文件描述符锁，需要设置CLONE_FILES

* 关闭最后一个关联文件描述符时自动释放

* 在同一个文件上，一个读锁一个写锁，或者两个写锁，这两个组合中一个是传统记录锁，一个文件描述符锁时，会冲突

* 使用文件描述符锁替换文件描述符上的另一个文件描述符锁是兼容的，但是文件描述符必须是同一个或者是dup，fork，fcntl(F_DUPFD)
用不同的open文件描述符来设置文件描述符锁会冲突，因此线程之间可以各自使用open打开文件，用文件描述符锁来同步访问。

在使用下面的命令时，flock结构体中l_pid需设置为0，

> F_OFD_SETLK  l_type是F_RDLCK或F_WRLCK，F_UNLCK，如果和其它进程冲突，返回-1，errno置为EAGAIN
>
> F_OFD_SETLKW F_OFD_SETLK等待版，如果在等待过程被信号中断，在信号处理函数返回后，返回-1，errno置为EINTR
>
>F_OFD_GETLK  测试能否在放置一个文件描述符锁，如果能，flock结构体l_type置为F_UNLCK，其它不变，但是并不会真正设置锁，如果其它锁阻止，不能放置锁，则返回已经设置锁的信息

### Mandatory locking 强制锁

如果进程去操作一个上锁的文件区域，如果设置了O_NONBLOCK，则出错返回，errno置为EAGAIN，否则一直等待可用或者被信号中断。

### 例子

    #include "apue.h"
    #include <fcntl.h>

    int main(int argc, char *argv[])
    {
    	int		val;

    	if (argc != 2)
    		err_quit("usage: a.out <descriptor#>");

    	if ((val = fcntl(atoi(argv[1]), F_GETFL, 0)) < 0)
    		err_sys("fcntl error for fd %d", atoi(argv[1]));

    	switch (val & O_ACCMODE) {
    	case O_RDONLY:
    		printf("read only");
    		break;

    	case O_WRONLY:
    		printf("write only");
    		break;

    	case O_RDWR:
    		printf("read write");
    		break;

    	default:
    		err_dump("unknown access mode");
    	}

    	if (val & O_APPEND)
    		printf(", append");
    	if (val & O_NONBLOCK)
    		printf(", nonblocking");
    	if (val & O_SYNC)
    		printf(", synchronous writes");

    #if !defined(_POSIX_C_SOURCE) && defined(O_FSYNC) && (O_FSYNC != O_SYNC)
    	if (val & O_FSYNC)
    		printf(", synchronous writes");
    #endif

    	putchar('\n');
    	exit(0);
    }

### 强制锁和建议锁区别

1. Advisory Lockin
尝试性文件锁需要各个进程的无私合作，试想A进程获得一个 写 的文件锁，它开始往文件里写操作。 同时B进程，却没有去尝试获取写操作，它也同样可以进行写操作。但是很显然，B进程违反了游戏规则。我们称之为不合作进程。 尝试性文件锁，需要各个进程遵守统一规则，在文件访问时，都要礼貌的去尝试获得文件锁，然后进一步操作。

2. Mandatory Locking
强制性文件锁不需要进程的合作，强制性文件锁是通过内核强制检查文件的打开，读写操作是否符合文件锁的使用规则。为了是强制性文件锁工作，我们必须要在文件系统上激活它，必要的操作包括挂载mount文件系统，通过 “-o mand”参数选项，对于文件锁施加的文件，打开 set-group-id 位，并且关闭 group-execute 位。我们必须选择这种顺序，因为你一旦关闭 group-execute 位，set-group-id 就没有意义了

## ioctl

    #include <unistd.h>
    #include <sys/ioctl.h>
    int ioctl(int fd, int request, ...);

对于不同的文件类型，还需引入不同的头文件

    类别			变量名		 头文件
    盘标号          DIOXXX       <sys/disklabel.h>
    文件IO          FIOXXX       <sys/filio.h>
    磁带IO          MTIOXXX      <sys/mtio.h>
    套接字IO        SIOXXX       <sys/sockio.h>
    终端IO          TIOXXX       <sys/ttycom.h>

    typedef long time_t;
    #ifndef _TIMESPEC
    #define _TIMESPEC
    struct timespec {
    	time_t tv_sec; // seconds
    	long tv_nsec; // and nanoseconds
    };
    #endif

# 不带缓冲IO

## open、openat、creat、lseek、lseek64、_llseek、close

    #include <sys/types.h>
    #include <sys/stat.h>
    #include <fcntl.h>
    #include <unistd.h>
    int open(const char *pathname, int flags);
    int open(const char *pathname, int flags, mode_t mode);
    int openat(int dirfd, const char *pathname, int flags);
    int openat(int dirfd, const char *pathname, int flags, mode_t mode);
    int name_to_handle_at(int dirfd, const char *pathname, struct file_handle *handle, int *mount_id, int flags);

    int open_by_handle_at(int mount_fd, struct file_handle *handle, int flags);
    int creat(const char *pathname, mode_t mode);
    int close(int fd);
    off_t lseek(int fd, off_t offset, int whence);
    off64_t lseek64(int fd, off64_t offset, int whence);
    int _llseek(unsigned int fd, unsigned long offset_high, unsigned long offset_low, loff_t *result, unsigned int whence);

pathname是相对路径时，open是相对当前工作路径，openat相对dirfd，当dirfd是AT_FDCWD时，路径相对于当前工作目录。当是绝对路径时，忽略dirfd，open、openat函数返回的文件描述符一定是最小的未用文件描述符数值。openat解决了TOCTTOU错误，即两个基于文件的函数调用，其中第二个调用依赖于第一个调用结果，那么可能在第一个调用后，文件被替换，第二个调用使用了错误文件，造成安全问题。

lseek为打开文件设置偏移，**当打开管道、FIFO或socket时返回-1，errno置为ESPIPE,lseek不会引起IO，偏移量可以大于文件长度，构成空洞，空洞都读为0，空洞不一定占用磁盘空间，由文件系统决定**，whence:

* SEEK_SET 从文件开始处
* SEEK_CUR
* SEEK_END

creat等价于

    open(pathname, O_WRONLY | OCREAT | O_TRUNC, mode)

mode只在O_CREAT和O_TMPFILE下有用，创建的文件权限是mode & ~umask。

## open

当同时用O_CREATE和O_EXCL调用open时，open出错返回，errno置为EEXIST

### flags:

    O_RDONLY            只读打开
    O_WRONLY            只写打开
    O_RDWR              读、写打开
    O_EXEC              只执行打开
    O_SEARCH            只搜索打开（应用于目录）
    O_APPEND            追加写
    O_CLOEXEC           FD_CLOEXEC常量设置为文件描述符标志，默认exec后文件描述符会保留
    O_CREAT             文件不存在则创建，所有者权限是进程的有效用户ID，假如父目录设置了SGID，则组权限是父目录的组权限，否则是进程的有效组ID，

             S_IRWXU  00700 user (file owner) has read, write, and execute permission
             S_IRUSR  00400 user has read permission
             S_IWUSR  00200 user has write permission
             S_IXUSR  00100 user has execute permission
             S_IRWXG  00070 group has read, write, and execute permission
             S_IRGRP  00040 group has read permission
             S_IWGRP  00020 group has write permission
             S_IXGRP  00010 group has execute permission
             S_IRWXO  00007 others have read, write, and execute permission
             S_IROTH  00004 others have read permission
             S_IWOTH  00002 others have write permission
             S_IXOTH  00001 others have execute permission

             According to POSIX, the effect when other bits are set in mode
             is unspecified.  On Linux, the following bits are also honored
             in mode:

             S_ISUID  0004000 set-user-ID bit
             S_ISGID  0002000 set-group-ID bit (see inode(7)).
             S_ISVTX  0001000 sticky bit (see inode(7)).

    O_DIRECTORY         pathname不是目录则出错
    O_EXCL              序同时指定O_CREAT，文件已存在则出错，用来测试文件是否存在，是原子操作，两者同时指定时，不会跟随符号链接。只有在pathname指向块设备时，可以不同时指定O_CREAT，此时如果设备忙，则出错返回，errno置为EBUSY
    O_NOCTTY            pathname指向终端，则此设备不分配为进程的控制终端
    O_NOFOLLOW          pathname符号链接，则出错
    O_NONBLOCK/O_NDELAY          pathname引用一个FIFO、一个块特殊文件或字符特殊文件，则本次打开操作和后续I/O操作设置非阻塞方式
    O_SYNC              每次write等待物理IO完成，包括文件属性更新所需IO
    O_TRUNC             文件存在，当只写或者读写打开时，将长度截断为0
    O_TTY_INIT          如果是打开一个还未打开的终端设备，设置非标准termios参数
    O_DSYNC             每次write等待IO操作完成，如果写操作不影响读取刚写入的数据，则不需要等待文件属性更新
    O_RSYNC             以文件描述符为参数的read操作等待，直至对文件同一部分挂起的写操作完成
    O_DIRECT            不使用缓存，只同步数据不同步文件属性
    O_LARGEFILE         off64_t表示文件，需定义_LARGEFILE64_SOURCE
    O_NOATIME           不更新访问时间
    O_PATH              获取文件描述符，但是不会打开文件，
                        在此文件描述符上调用  read, write, fchmod, fchown, fgetxattr,ioctl, mmap会失败， close,fchdir,fstat,fstatfs,dup可以使用， fcntl带F_DUPFD或F_GETFD或F_SETFD也可以，F_GETFL会包括O_PATH标志，作为dirfd参数传递给openat等*at系统调用，包括linkat但是要带AT_EMPTY_PATH，or via procfs using
                 AT_SYMLINK_FOLLOW，通过unix域连接传递给其它进程。 O_CLOEXEC, O_DIRECTORY, and O_NOFOLLOW 被忽略
   O_TMPFILE            如果pathname是文件夹则该临时文件没有名字，当最后一个关联文件描述符关闭时，所有内容丢失。除非pathname指向一个文件。必须搭配O_RDWR，O_WRONLY，O_EXCL可有可无，O_EXCL没有设置的话，可以用linkat创建一个连接文件指向这个临时文件。

O_TMPFILE作用

1. 提高tmpfile函数作用，无竟态的创建一个临时文件，在关闭时会自动删除，不能被任一路径访问。避免符号链接攻击，无需设计一个唯一名字。
2. 可以在配置完整文件属性后，才让linkat链接过来，增强安全性。

### errno

    EACCES 没有文件访问权限或者路径中任一目录没有搜索权限，文件不存在或者文件所在目录没有写权限
    EDQUOT 当O_CREAT设置，但是文件块或者inode配额用完
    EEXIST 当文件存在并且设置了O_CREAT和O_EXCL
    EFAULT 指向不可访问空间
    EFBIG/EOVERFLOW
    EINTR 等待慢速设备比如（FIFO）被信号中断
    EINVAL 文件系统不支持O_DIRECT
    EINVAL flags错误，比如设置了O_TMPFILE，但是没有设置 O_WRONLY或O_RDWR
    EISDIR 指向了目录，同时设置了写（O_WRONLY或O_RDWR）。或者指向目录，同时设置了O_TMPFILE，以及 O_WRONLY、O_RDWR两者之一，但是内核不支持O_TMPFILE
    ELOOP  解析符号链接时遇到太多符号链接（可能形成环了）。或者pathname是符号链接，但是标志位指定了O_NOFOLLOW而没有指定O_PATH
    ENAMETOOLONG
    ENFILE 整个系统打开文件数目太多
    ENODEV pathname指向一个设备，但是设备不存在
    ENOENT 指定了O_CREAT，但是文件不存在。或者指向一个不存在的目录，但是指定了O_TMPFILE， O_WRONLY和O_RDWR两者其一，但是内核不支持O_TMPFILE

    ENOMEM 指向一个管道，但是进程可分配管道内存不够，而进程又没有足够权限。或者内核内存不够

    ENOSPC 创建了文件名，但是磁盘没有空间写文件
    ENOTDIR 指定了O_DIRECTORY，但是pathname不指向文件夹
    ENXIO  命名FIFO，并且设置了O_NONBLOCK和O_WRONLY。或者pathname指向一个设备，但是设备不存在
    EOPNOTSUPP 文件系统有pathname文件，但是不支持O_TMPFILE
    EOVERFLOW 文件大于系统支持的最大文件大小
    EPERM 指定了O_NOATIME，但是有效用户ID不等于文件用户ID，并且进程没有足够的权限。或者被file seal阻止。
    EROFS  pathname指向只读文件系统上文件，但是设置了写（O_WRONLY或O_RDWR）
    ETXTBSY pathname指向一个可执行文件，并且正在执行，此时设置了写（O_WRONLY或O_RDWR）
    EWOULDBLOCK 设置了O_NONBLOCK，但是文件有一个不兼容的**文件租约。**

    openat专属
    EBADF  错误文件描述符
    ENOTDIR  pathname是个相对路径，并且dirfd指向一个文件而不是文件夹

## read

    ssize_t read(int fd, void *buf, size_t count);

成功后返回已经读到字节数。出错返回-1，

    EAGAIN 指向的文件描述符不是socket时，当文件描述符设置为O_NONBLOCK，则立刻返回
    EAGAIN or EWOULDBLOCK 指向的文件描述符是socket时，当文件描述符设置为O_NONBLOCK，则立刻返回，EAGAIN或EWOULDBLOCK都应该测试
    EBADF  非法文件描述符
    EFAULT 读取空间非法
    EINTR  没读到任何数据被中断
    EINVAL fd指向的文件不能读，或者文件以O_DIRECT模式打开，buf或者count没有对齐。或者fd由timerfd_create打开并且是错误的buf大小
    EIO    后台进程组读控制终端，但是SIGTTIN被阻塞或者忽略，或者属于一个孤儿进程组。当磁盘错误时，也可能置为EIO
    EISDIR fd指向目录

## write：

    ssize_t write(int fd, const void *buf, size_t count);

errno:

    EAGAIN 指向的文件描述符不是socket时，当文件描述符设置为O_NONBLOCK，则立刻返回
    EAGAIN or EWOULDBLOCK 指向的文件描述符是socket时，当文件描述符设置为O_NONBLOCK，则立刻返回，EAGAIN或EWOULDBLOCK都应该测试
    EBADF  非法文件描述符
    EDESTADDRREQ fd指向一个udp连接，但是连接没有调用connect
    EDQUOT 可写空间超过配额
    EFAULT 读取空间非法
    EFBIG  大于最大可写数目
    EINTR  没写任何数据被中断
    EINVAL fd指向的文件不能写，或者文件以O_DIRECT模式打开，buf或者count没有对齐
    EIO    修改inode的时候发生低级IO错误
    ENOSPC 磁盘空间满
    EPERM  被(file seal)阻止
    EPIPE  fd指向管道或者socket，但是读端关闭了。同时会收到SIGPIPE信号。

### 例子

    #include "apue.h"

    #define	BUFFSIZE	4096

    int
    main(void)
    {
    	int		n;
    	char	buf[BUFFSIZE];

    	while ((n = read(STDIN_FILENO, buf, BUFFSIZE)) > 0)
    		if (write(STDOUT_FILENO, buf, n) != n)
    			err_sys("write error");

    	if (n < 0)
    		err_sys("read error");

    	exit(0);
    }

CTRL+D等价于EOF

    #include "apue.h"

    int
    main(void)
    {
    	int		c;

    	while ((c = getc(stdin)) != EOF)
    		if (putc(c, stdout) == EOF)
    			err_sys("output error");

    	if (ferror(stdin))
    		err_sys("input error");

    	exit(0);
    }

## 先偏移再读写，pread pwrite

    #include <unistd.h>
    ssize_t pread(int fd, void *buf, size_t count, off_t offset);
    ssize_t pwrite(int fd, const void *buf, size_t count, off_t offset);

从当前文件偏移量 + offset开始读写，相当于先lseek再read/write但是是原子操作。

## 锁操作

### flock设置锁

    int flock(int fd, int operation);

flock() 操作的 handle 必须是一个已经打开的文件指针。operation 可以是以下值之一：

1. 要取得共享锁定（读取程序），将 operation 设为 LOCK_SH（PHP 4.0.1 以前的版本设置为 1）。
2. 要取得独占锁定（写入程序），将 operation 设为 LOCK_EX（PHP 4.0.1 以前的版本中设置为 2）。
3. 要释放锁定（无论共享或独占），将 operation 设为 LOCK_UN（PHP 4.0.1 以前的版本中设置为 3）。
4. 如果你不希望 flock() 在锁定时堵塞，则给 operation 加上 LOCK_NB（PHP 4.0.1 以前的版本中设置为 4）。

flock只是建议性锁，不能在 NFS 以及其他的一些网络文件系统中正常工作。


flock创建的锁是和文件打开表项（struct file）相关联的，而不是fd。这就意味着复制文件fd（通过fork或者dup）后，那么通过这两个fd都可以操作这把锁（例如通过一个fd加锁，通过另一个fd可以释放锁），也就是说子进程继承父进程的锁。但是上锁过程中关闭其中一个fd，锁并不会释放（因为file结构并没有释放），只有关闭所有复制出的fd，锁才会释放。

使用open两次打开同一个文件，得到的两个fd是独立的（因为底层对应两个file对象），通过其中一个加锁，通过另一个无法解锁，并且在前一个解锁前也无法上锁

使用exec后，文件锁的状态不变。

flock锁可递归，即通过dup或者或者fork产生的两个fd，都可以加锁而不会产生死锁。

 ### lockf设置锁

    int lockf(int fd, int cmd, off_t len);

 fd为通过open返回的打开文件描述符。

  cmd的取值为：

  * F_LOCK：给文件互斥加锁，若文件以被加锁，则会一直阻塞到锁被释放。
  * F_TLOCK：同F_LOCK，但若文件已被加锁，不会阻塞，而回返回错误。
  * F_ULOCK：解锁。
  * F_TEST：测试文件是否被上锁，若文件没被上锁则返回0，否则返回-1。

  len：为从文件当前位置的起始要锁住的长度。

  通过函数参数的功能，可以看出lockf只支持排他锁，不支持共享锁。


### fcntl设置文件锁

    struct f_owner_ex {
    	int   type;
    	pid_t pid;
    };

    struct flock
    {
    	short l_type;/*F_RDLCK，读共享锁, F_WRLCK，写互斥锁, or F_UNLCK对一个区域解锁*/
    	off_t l_start;/*相对于l_whence的偏移值，字节为单位*/
    	short l_whence;/*从哪里开始：SEEK_SET, SEEK_CUR, or SEEK_END*/
    	off_t l_len;/*长度, 字节为单位; 0 意味着缩到文件结尾*/
    	pid_t l_pid;/*returned with F_GETLK*/
    };

    #include <unistd.h>
    #include <fcntl.h>
    int fcntl(int fd, int cmd, ...);

#### 建议性记录锁

第三个指针参数指向flock参数

* F_GETLK

* F_SETLK  设置锁或者释放锁，设置锁系统会检测死锁，如果发现死锁，出错返回errno位置EDEADLK

* F_SETLKW 对应着F_SETLK的可以阻塞的版本。w意味着wait，等待过程被信号中断，从信号处理函数返回后再返回-1，errno置为EINTR

> 锁可以开始或者超过文件当前结束位置，但是不可以开始或者超过文件的开始位置
>
> 如果l_len为0，意味着锁的区域为可以到达的最大文件偏移位置。这个类型，可以让我们锁住一个文件的任意开始位置，结束的区域可以到达任意的文件结尾，并且以append方式追加文件时，也会同样上锁
>
>如果要锁住整个文件，设置l_start 和 l_whence为文件的开始位置（l_start为0 l_whence 为 SEEK_SET ），并且l_len为0。
>
>如果有多个读共享锁(l_type of F_RDLCK),其他的读共享锁可以接受，但是写互斥锁(type ofF_WRLCK)拒绝
>
>如果有一个写互斥锁(type ofF_WRLCK),其他的读共享锁(l_type of F_RDLCK)拒绝，其他的写互斥锁拒绝。
>
>如果要取得读锁，这个文件描述符必须被打开可以去读；如果要或者写锁，这个文件的描述符必须可以被打开可以去写。
>
>进程终止后会释放所有锁
>
>由fork产生的子进程不继承父进程所设置的锁，这点与flock也不同。
>
>标准IO因为使用了缓存，应该避免使用锁。使用不带缓存的IO
>
>关闭任何文件描述符会导致关联文件上的锁被释放，所以A进程会影响B进程，与flock不同
>
>线程之间共享记录锁
 >
 >上锁可递归，如果一个进程对一个文件区间已经有一把锁，后来进程又企图在同一区间再加一把锁，则新锁将替换老锁。
 >
 >进程不能使用F_GETLK命令来测试它自己是否再文件的某一部分持有一把锁。F_GETLK命令定义说明，返回信息指示是否现存的锁阻止调用进程设置它自己的锁。因为，F_SETLK和F_SETLKW命令总是替换进程的现有锁，所以调用进程绝不会阻塞再自己持有的锁上，于是F_GETLK命令绝不会报告调用进程自己持有的锁。

#### 文件描述符锁

* 文件描述符锁和文件描述符相关联，而不是和进程。

* fork和clone后会继承文件描述符锁，需要设置CLONE_FILES

* 关闭最后一个关联文件描述符时自动释放

* 在同一个文件上，一个读锁一个写锁，或者两个写锁，这两个组合中一个是传统记录锁，一个文件描述符锁时，会冲突

* 使用文件描述符锁替换文件描述符上的另一个文件描述符锁是兼容的，但是文件描述符必须是同一个或者是dup，fork，fcntl(F_DUPFD)
用不同的open文件描述符来设置文件描述符锁会冲突，因此线程之间可以各自使用open打开文件，用文件描述符锁来同步访问。

在使用下面的命令时，flock结构体中l_pid需设置为0，

> F_OFD_SETLK  l_type是F_RDLCK或F_WRLCK，F_UNLCK，如果和其它进程冲突，返回-1，errno置为EAGAIN
>
> F_OFD_SETLKW F_OFD_SETLK等待版，如果在等待过程被信号中断，在信号处理函数返回后，返回-1，errno置为EINTR
>
>F_OFD_GETLK  测试能否在放置一个文件描述符锁，如果能，flock结构体l_type置为F_UNLCK，其它不变，但是并不会真正设置锁，如果其它锁阻止，不能放置锁，则返回已经设置锁的信息

#### Mandatory locking 强制锁

如果进程去操作一个上锁的文件区域，如果设置了O_NONBLOCK，则出错返回，errno置为EAGAIN，否则一直等待可用或者被信号中断。

### flock、lockf、fcntl之间关系

flock和lockf/fcntl所上的锁互不影响。

POSIX FLOCK 这个比较明确，就是哪个类型的锁。flock系统调用产生的是FLOCK，fcntl调用F_SETLK，F_SETLKW或者lockf产生的是POSIX类型，

# 标准IO库

    #include <stdio.h>
    #include <wchar.h>
    int fwide(FILE *fp, int mode);//设定流定向，mode为负数字节定向，为正数，则宽定向，0返回当前定向

标准IO支持单字节和多字节，由流定向决定，流打开的时候并没有确定定向，当在一个流上使用多字节IO函数时，则宽定向定向，使用单字节IO函数则单字节定向，fwide不会改变已经设置的流定向。fwide无出错返回，只能靠errno判断

## 缓冲类型

标准I/O缓冲会在fork后复制到子进程

### 全缓冲：

填满标准IO缓冲区后才进行实际IO操作。

### 行缓冲

输入输出遇到换行符时，标准IO库执行实际IO操作。

> * 因为缓冲行大小是有限的，在填满缓冲行时，即使没有遇到换行符，也冲刷
>
> * 任何时候只要通过标准IO要求从一个不带缓冲的流或者从一个行缓冲流输入数据，就会冲洗所有行缓冲输出流。

### 不带缓冲

立刻输出，stderr是不带缓冲的流，交互式设备一般是行缓冲

***标准输入和输出并不指向交互式设备时，才是全缓冲的***

## 设置缓冲

    #include <stdio.h>
    void setbuf(FILE *stream, char *buf);//设置缓冲区为buf，如果流和终端设备相关，则是行缓冲，其它情况都是全缓冲，buf为NULL关闭缓冲区
    void setbuffer(FILE *stream, char *buf, size_t size);
    void setlinebuf(FILE *stream);
    int setvbuf(FILE *stream, char *buf, int mode, size_t size);
    _IOFBF全缓冲,_IOLBF行缓冲,_IONBF不带缓冲， buf为NULL，标准IO库会自动分配缓冲区

mode:

    r/rb
    w/wb 截断为0写
    a/ab
    r+/r+b/rb+ 读写打开，不会截断为0
    w+/w+b/wb+ 读写打开，会截断为0
    a+/a+b/ab+

## 冲洗流fflush

    int fflush(FILE *stream);冲刷指定流到内核，如果stream为NULL，则冲刷所有流

读写打开一个文件时，

* 如果输出如果没有fflush，fseek，fsetpos rewind后面不能跟随输入时，
* 如果中间没有fseek，fsetpos或rewind，或者一个输入操作没有到达文件尾端，输入操作后不能直接跟随输出。

## 打开流，fopen, fdopen, freopen

    FILE *fopen(const char *pathname, const char *mode);
    FILE *fdopen(int fd, const char *mode);//将一个流和fd绑定，不会截断fd文件，因为fd已经打开
    FILE *freopen(const char *pathname, const char *mode, FILE *stream);

在指定的流上打开一个指定文件，如果流已经打开，先关闭流，如果已经定向，会先关闭定向

## 关闭流，fclose

    int fclose(FILE *fp);
    int fcloseall(void);

冲洗缓冲中输出数据，缓冲区任何输入丢弃，释放缓冲区，关闭文件。调用exit或者从main返回时，进程所有流都被冲洗。

## 清空流

    int fpurge(FILE *stream);

丢弃所有未读或未写数据。

## 流二进制IO （直接IO）

***标准IO中的直接IO指的二进制读写，一次性读写一个对象，跟open中的O_DIRECT没有任何关系。***

### 流读写，fread、fwrite

    size_t fread(void *ptr, size_t size, size_t nmemb, FILE *stream);
    size_t fwrite(const void *ptr, size_t size, size_t nmemb, FILE *stream);

### 流定位，fseek、ftell、rewind、fgetpos、fsetpos、fseeko、ftello

    int fseek(FILE *stream, long offset, int whence);
    long ftell(FILE *stream);
    void rewind(FILE *stream);

    int fgetpos(FILE *stream, fpos_t *pos);
    int fsetpos(FILE *stream, const fpos_t *pos);
    int fseeko(FILE *stream, off_t offset, int whence);
    off_t ftello(FILE *stream);

whence:

    SEEK_SET,
    SEEK_CUR,
    or SEEK_END

## 不加锁流操作

    int getc_unlocked(FILE *stream);
    int getchar_unlocked(void);
    int putc_unlocked(int c, FILE *stream);
    int putchar_unlocked(int c);

    void clearerr_unlocked(FILE *stream);
    int feof_unlocked(FILE *stream);
    int ferror_unlocked(FILE *stream);
    int fileno_unlocked(FILE *stream);
    int fflush_unlocked(FILE *stream);
    int fgetc_unlocked(FILE *stream);
    int fputc_unlocked(int c, FILE *stream);
    size_t fread_unlocked(void *ptr, size_t size, size_t n, FILE *stream);
    size_t fwrite_unlocked(const void *ptr, size_t size, size_t n, FILE *stream);

    char *fgets_unlocked(char *s, int n, FILE *stream);
    int fputs_unlocked(const char *s, FILE *stream);

    #include <wchar.h>

    wint_t getwc_unlocked(FILE *stream);
    wint_t getwchar_unlocked(void);
    wint_t fgetwc_unlocked(FILE *stream);
    wint_t fputwc_unlocked(wchar_t wc, FILE *stream);
    wint_t putwc_unlocked(wchar_t wc, FILE *stream);
    wint_t putwchar_unlocked(wchar_t wc);
    wchar_t *fgetws_unlocked(wchar_t *ws, int n, FILE *stream);
    int fputws_unlocked(const wchar_t *ws, FILE *stream);

## 流加锁操作，flockfile、ftrylockfile、funlockfile

    #include <stdio.h>
    int ftrylockfile(FILE *fp);
    OK返回0，不能获取锁返回非0值
    void flockfile(FILE *fp);
    void funlockfile(FILE *fp);

获取FILE关联对象锁，递归锁

    int getchar_unlocked(void);
    int getc_unlocked(FILE *fp);
    Both return: the next character if OK, EOF on end of file or error
    int putchar_unlocked(int c);
    int putc_unlocked(int c, FILE *fp);
    Both return: c if OK, EOF on error

除非被flockfile，ftrylockfile或funlockfile调用包围，否则不能调用以上函数。这些函数用来避免每次都对FILE对象加锁，提高性能

## 流utility，__fbufsize、__flbf、__freadable、__fwritable、__freading、__fwriting、__fsetlocking、_flushlbf、__fpurge

    #include <stdio.h>
    #include <stdio_ext.h>

    size_t __fbufsize(FILE *stream);

返回流缓冲大小

    size_t __fpending(FILE *stream);

返回输出流字节数目，对输入流没有定义

    int __flbf(FILE *stream);

如果流是行缓冲返回非0值，否则返回0

    int __freadable(FILE *stream);

流允许读返回非0值，否则返回0

    int __fwritable(FILE *stream);

流允许写返回非0值，否则返回0

    int __freading(FILE *stream);

流只读返回非0值，否则返回1其它值

    int __fwriting(FILE *stream);

流只写返回非0值，否则返回其它值

    int __fsetlocking(FILE *stream, int type);

设定流的锁类型，返回目前的锁类型：

FSETLOCKING_INTERNAL 除非对于*_unlocked流操作，否则此流上所有操作施加隐式锁，这是默认情况

FSETLOCKING_BYCALLER 流不会自动加锁，需要调用flockfile

FSETLOCKING_QUERY 不改变锁类型

    void _flushlbf(void);

冲刷所有行缓冲

    void __fpurge(FILE *stream);

丢弃目前流中内容

## 格式化流读

    int scanf(const char *format, ...);
    int fscanf(FILE *stream, const char *format, ...);
    int sscanf(const char *str, const char *format, ...);

    #include <stdarg.h>
    int vscanf(const char *format, va_list ap);
    int vsscanf(const char *str, const char *format, va_list ap);
    int vfscanf(FILE *stream, const char *format, va_list ap);

## 格式化流写

    #include <stdio.h>

    int printf(const char *format, ...);
    int fprintf(FILE *stream, const char *format, ...);
    int dprintf(int fd, const char *format, ...);
    int sprintf(char *str, const char *format, ...);
    int snprintf(char *str, size_t size, const char *format, ...);

    #include <stdarg.h>

    int vprintf(const char *format, va_list ap);
    int vfprintf(FILE *stream, const char *format, va_list ap);
    int vdprintf(int fd, const char *format, va_list ap);
    int vsprintf(char *str, const char *format, va_list ap);
    int vsnprintf(char *str, size_t size, const char *format, va_list ap);

    #include <stdio.h>
    #include <wchar.h>

    int wprintf(const wchar_t *format, ...);
    int fwprintf(FILE *stream, const wchar_t *format, ...);
    int swprintf(wchar_t *wcs, size_t maxlen, const wchar_t *format, ...);

    int vwprintf(const wchar_t *format, va_list args);
    int vfwprintf(FILE *stream, const wchar_t *format, va_list args);
    int vswprintf(wchar_t *wcs, size_t maxlen, const wchar_t *format, va_list args);

    int asprintf(char **strp, const char *fmt, ...);
    int vasprintf(char **strp, const char *fmt, va_list ap);

## 流错误

这些函数调用出错或者到达文件末尾无法区分，需要调用

    int ferror(FILE *fp);
    int feof(FILE *fp);
    void clearerr(FILE *fp);

FILE中保存了出错标志和文件结束标志。

## fileno

    int fileno(FILE *fp);//获取流的fd

## 测试流EOF

    int feof(FILE *stream);

测试流是否遇到EOF

## 例子

    #include "apue.h"

    void	pr_stdio(const char *, FILE *);
    int		is_unbuffered(FILE *);
    int		is_linebuffered(FILE *);
    int		buffer_size(FILE *);

    int main(void)
    {
    	FILE	*fp;

    	fputs("enter any character\n", stdout);
    	if (getchar() == EOF)
    		err_sys("getchar error");
    	fputs("one line to standard error\n", stderr);

    	pr_stdio("stdin", stdin);
    	pr_stdio("stdout", stdout);
    	pr_stdio("stderr", stderr);

    	if ((fp = fopen("/etc/passwd", "r")) == NULL)
    		err_sys("fopen error");
    	if (getc(fp) == EOF)
    		err_sys("getc error");
    	pr_stdio("/etc/passwd", fp);
    	exit(0);
    }

    void pr_stdio(const char *name, FILE *fp)
    {
    	printf("stream = %s, ", name);
    	if (is_unbuffered(fp))
    		printf("unbuffered");
    	else if (is_linebuffered(fp))
    		printf("line buffered");
    	else /* if neither of above */
    		printf("fully buffered");
    	printf(", buffer size = %d\n", buffer_size(fp));
    }

    /*
    * The following is nonportable.
    */

    #if defined(_IO_UNBUFFERED)

    int
    is_unbuffered(FILE *fp)
    {
    	return(fp->_flags & _IO_UNBUFFERED);
    }

    int
    is_linebuffered(FILE *fp)
    {
    	return(fp->_flags & _IO_LINE_BUF);
    }

    int
    buffer_size(FILE *fp)
    {
    	return(fp->_IO_buf_end - fp->_IO_buf_base);
    }

    #elif defined(__SNBF)

    int
    is_unbuffered(FILE *fp)
    {
    	return(fp->_flags & __SNBF);
    }

    int
    is_linebuffered(FILE *fp)
    {
    	return(fp->_flags & __SLBF);
    }

    int
    buffer_size(FILE *fp)
    {
    	return(fp->_bf._size);
    }

    #elif defined(_IONBF)

    #ifdef _LP64
    #define _flag __pad[4]
    #define _ptr __pad[1]
    #define _base __pad[2]
    #endif

    int
    is_unbuffered(FILE *fp)
    {
    	return(fp->_flag & _IONBF);
    }

    int
    is_linebuffered(FILE *fp)
    {
    	return(fp->_flag & _IOLBF);
    }

    int
    buffer_size(FILE *fp)
    {
    #ifdef _LP64
    	return(fp->_base - fp->_ptr);
    #else
    	return(BUFSIZ);	/* just a guess */
    #endif
    }

    #else

    #error unknown stdio implementation!

    #endif

## 内存流

    FILE *fmemopen(void *buf, size_t size, const char *mode);需要指定buf
    #include <stdio.h>
    FILE *open_memstream(char **ptr, size_t *sizeloc);自动分配buf
    #include <wchar.h>
    FILE *open_wmemstream(wchar_t **ptr, size_t *sizeloc);

    FILE *fopencookie(void *cookie, const char *mode, cookie_io_functions_t io_funcs);

用来实现内存流

    typedef struct {
      cookie_read_function_t  *read;
      cookie_write_function_t *write;
      cookie_seek_function_t  *seek;
      cookie_close_function_t *close;
    } cookie_io_functions_t;

    #define _GNU_SOURCE
    #include <sys/types.h>
    #include <stdio.h>
    #include <stdlib.h>
    #include <unistd.h>
    #include <string.h>

    #define INIT_BUF_SIZE 4

    struct memfile_cookie {
        char   *buf;        /* Dynamically sized buffer for data */
        size_t  allocated;  /* Size of buf */
        size_t  endpos;     /* Number of characters in buf */
        off_t   offset;     /* Current file offset in buf */
    };

    ssize_t
    memfile_write(void *c, const char *buf, size_t size)
    {
        char *new_buff;
        struct memfile_cookie *cookie = c;

        /* Buffer too small? Keep doubling size until big enough */

        while (size + cookie->offset > cookie->allocated) {
            new_buff = realloc(cookie->buf, cookie->allocated * 2);
            if (new_buff == NULL) {
                return -1;
            } else {
                cookie->allocated *= 2;
                cookie->buf = new_buff;
            }
        }

        memcpy(cookie->buf + cookie->offset, buf, size);

        cookie->offset += size;
        if (cookie->offset > cookie->endpos)
            cookie->endpos = cookie->offset;

        return size;
    }

    ssize_t
    memfile_read(void *c, char *buf, size_t size)
    {
        ssize_t xbytes;
        struct memfile_cookie *cookie = c;

        /* Fetch minimum of bytes requested and bytes available */

        xbytes = size;
        if (cookie->offset + size > cookie->endpos)
            xbytes = cookie->endpos - cookie->offset;
        if (xbytes < 0)     /* offset may be past endpos */
           xbytes = 0;

        memcpy(buf, cookie->buf + cookie->offset, xbytes);

        cookie->offset += xbytes;
        return xbytes;
    }

    int
    memfile_seek(void *c, off64_t *offset, int whence)
    {
        off64_t new_offset;
        struct memfile_cookie *cookie = c;

        if (whence == SEEK_SET)
            new_offset = *offset;
        else if (whence == SEEK_END)
            new_offset = cookie->endpos + *offset;
        else if (whence == SEEK_CUR)
            new_offset = cookie->offset + *offset;
        else
            return -1;

        if (new_offset < 0)
            return -1;

        cookie->offset = new_offset;
        *offset = new_offset;
        return 0;
    }

    int
    memfile_close(void *c)
    {
        struct memfile_cookie *cookie = c;

        free(cookie->buf);
        cookie->allocated = 0;
        cookie->buf = NULL;

        return 0;
    }

    int
    main(int argc, char *argv[])
    {
        cookie_io_functions_t  memfile_func = {
            .read  = memfile_read,
            .write = memfile_write,
            .seek  = memfile_seek,
            .close = memfile_close
        };
        FILE *stream;
        struct memfile_cookie mycookie;
        ssize_t nread;
        long p;
        int j;
        char buf[1000];

        /* Set up the cookie before calling fopencookie() */

        mycookie.buf = malloc(INIT_BUF_SIZE);
        if (mycookie.buf == NULL) {
            perror("malloc");
            exit(EXIT_FAILURE);
        }

        mycookie.allocated = INIT_BUF_SIZE;
        mycookie.offset = 0;
        mycookie.endpos = 0;

        stream = fopencookie(&mycookie,"w+", memfile_func);
        if (stream == NULL) {
            perror("fopencookie");
            exit(EXIT_FAILURE);
        }

        /* Write command-line arguments to our file */

        for (j = 1; j < argc; j++)
            if (fputs(argv[j], stream) == EOF) {
                perror("fputs");
                exit(EXIT_FAILURE);
            }

        /* Read two bytes out of every five, until EOF */

        for (p = 0; ; p += 5) {
            if (fseek(stream, p, SEEK_SET) == -1) {
                perror("fseek");
                exit(EXIT_FAILURE);
            }
            nread = fread(buf, 1, 2, stream);
            if (nread == -1) {
                perror("fread");
                exit(EXIT_FAILURE);
            }
            if (nread == 0) {
                printf("Reached end of file\n");
                break;
            }

            printf("/%.*s/\n", nread, buf);
        }

        exit(EXIT_SUCCESS);
    }

# 异步IO

## sigevent、aiocb

    struct sigevent {
      int sigev_notify; /* notify type */
      int sigev_signo; /* signal number */
      union sigval sigev_value; /* notify argument */
      void (*sigev_notify_function)(union sigval); /* notify function */
      pthread_attr_t *sigev_notify_attributes; /* notify attrs */
    };

sigev_notify字段控制通知类型。

* SIGEV_NONE   异步IO请求完成后，不通知进程
* SIGEV_SIGNAL 异步IO完成后，产生由sigev_signo字段指定的信号。如果进程捕捉该信号，并且指定了SA_SIGINFO标志，则该信号将被入队列，给信号处理函数传递一个siginfo结构，该结构的si_value字段被设置为sigev_value。
* SIGEV_THREAD 异步IO完成后，由sigev_notify_function字段指定函数被调用。sigev_value作为唯一参数。除非sigev_notify_attributes字段设定了pthread属性结构的地址，且该结构指定了一个另外的线程属性，否则该函数将在分离状态下的一个单独线程中执行。

## aiocb

    struct aiocb {
    	int aio_fildes; /* file descriptor */
    	off_t aio_offset; /* file offset for I/O */
    	volatile void *aio_buf; /* buffer for I/O */
    	size_t aio_nbytes; /* number of bytes to transfer */
    	int aio_reqprio; /* priority */
    	struct sigevent aio_sigevent; /* signal information */
    	int aio_lio_opcode; /* operation for list I/O */
    };

异步IO接口必须指定偏移量，不会影响操作系统维护的文件偏移量。不能把异步IO系统调用和传统IO系统调用在同一个文件描述符混用。如果异步IO接口以追加模式打开文件写入数据，aio_offset字段被系统忽略。

## aio_read, aio_write

    #include <aio.h>
    int aio_read(struct aiocb *aiocb);
    int aio_write(struct aiocb *aiocb);

正常返回0，出错-1

函数返回成功时，异步IO请求只是被操作系统放入到等待队列中，这些函数返回值与实际IO操作没有任何关系。IO操作在等待时，AIO控制块和数据库缓冲区保持稳定。除非IO操作完成，否则。

## 冲洗异步IO数据，aio_fsync

    int aio_fsync(int op, struct aiocb *aiocb);

AIO控制块总的aio_filedes字段指定了异步操作的文件，如果op设定为O_DSYNC，操作执行起来就像调用了fdatasync。op设置为O_SYNC，就像调用了fsync。aio_fsync返回时，数据并不一定已经持久化。

## 判断异步IO完成状态，aio_error

    int aio_error(const struct aiocb *aiocb);

获取异步读写或者同步操作的完成状态

>0  异步操作完成。需要调用aio_return函数获取操作返回值
>
>-1 对aio_error调用失败。这种情况下，errno会告诉我们
>
EINPROGRESS  读写或同步操作仍在等待

## 获取异步IO返回，aio_return

    ssize_t aio_return(const struct aiocb *aiocb);

异步操作完成前，不要调用aio_return，本身失败返回-1，并置errno。

## 等待异步IO完成，aio_suspend

    int aio_suspend(const struct aiocb *const list[], int nent, const struct timespec *timeout);

阻塞进程，直到所有异步IO操作完成

* 成功返回0
* 出错返回-1
* 被信号中断返回-1，errno置为EINTR
* 超时返回-1，errno置为EAGAIN
* timeout为NULL永久等待

## 取消未完成异步IO，aio_cancel

    int aio_cancel(int fd, struct aiocb *aiocb);

取消未完成的异步IO操作，aiocb为NULL，系统将会取消fd上所有未完成异步IO。

aio_cancel返回值

* AIO_ALLDONE  所有操作已经在取消前完成
* AIO_CANCELED 操作已经被取消
* AIO_NOTCANCELED 至少有一个要求操作没有被取消
* -1 对aio_cancel调用失败，置errno

## 列表操作，lio_listio

    int lio_listio(int mode, struct aiocb *restrict const list[restrict], int nent, struct sigevent *restrict sigev);

* mode为LIO_WAIT，函数是同步的，函数在列表指定的所有IO操作完成后返回。此时sigev被忽略
* mode为IO_NOWAIT，函数将IO请求入队后立即返回。IO操作完成后按照sigev参数指定的被异步通知。可以将sigev置为NULL

aio_lio_opcode字段LIO_READ交由aio_read函数处理，LIO_WRITE交由aio_write处理，LIO_NOP被忽略。

## 异步IO操作例子

    #include "apue.h"
    #include <ctype.h>
    #include <fcntl.h>
    #include <aio.h>
    #include <errno.h>

    #define BSZ 4096
    #define NBUF 8

    enum rwop {
    	UNUSED = 0,
    	READ_PENDING = 1,
    	WRITE_PENDING = 2
    };

    struct buf {
    	enum rwop     op;
    	int           last;
    	struct aiocb  aiocb;
    	unsigned char data[BSZ];
    };

    struct buf bufs[NBUF];

    unsigned char
    translate(unsigned char c)
    {
    	if (isalpha(c)) {
    		if (c >= 'n')
    			c -= 13;
    		else if (c >= 'a')
    			c += 13;
    		else if (c >= 'N')
    			c -= 13;
    		else
    			c += 13;
    	}
    	return(c);
    }

    int
    main(int argc, char* argv[])
    {
    	int					ifd, ofd, i, j, n, err, numop;
    	struct stat			sbuf;
    	const struct aiocb	*aiolist[NBUF];
    	off_t				off = 0;

    	if (argc != 3)
    		err_quit("usage: rot13 infile outfile");
    	if ((ifd = open(argv[1], O_RDONLY)) < 0)
    		err_sys("can't open %s", argv[1]);
    	if ((ofd = open(argv[2], O_RDWR|O_CREAT|O_TRUNC, FILE_MODE)) < 0)
    		err_sys("can't create %s", argv[2]);
    	if (fstat(ifd, &sbuf) < 0)
    		err_sys("fstat failed");

    	/* initialize the buffers */
    	for (i = 0; i < NBUF; i++) {
    		bufs[i].op = UNUSED;
    		bufs[i].aiocb.aio_buf = bufs[i].data;
    		bufs[i].aiocb.aio_sigevent.sigev_notify = SIGEV_NONE;
    		aiolist[i] = NULL;
    	}

    	numop = 0;
    	for (;;) {
    		for (i = 0; i < NBUF; i++) {
    			switch (bufs[i].op) {
    			case UNUSED:
    				/*
    				 * Read from the input file if more data
    				 * remains unread.
    				 */
    				if (off < sbuf.st_size) {
    					bufs[i].op = READ_PENDING;
    					bufs[i].aiocb.aio_fildes = ifd;
    					bufs[i].aiocb.aio_offset = off;
    					off += BSZ;
    					if (off >= sbuf.st_size)
    						bufs[i].last = 1;
    					bufs[i].aiocb.aio_nbytes = BSZ;
    					if (aio_read(&bufs[i].aiocb) < 0)
    						err_sys("aio_read failed");
    					aiolist[i] = &bufs[i].aiocb;
    					numop++;
    				}
    				break;

    			case READ_PENDING:
    				if ((err = aio_error(&bufs[i].aiocb)) == EINPROGRESS)
    					continue;
    				if (err != 0) {
    					if (err == -1)
    						err_sys("aio_error failed");
    					else
    						err_exit(err, "read failed");
    				}

    				/*
    				 * A read is complete; translate the buffer
    				 * and write it.
    				 */
    				if ((n = aio_return(&bufs[i].aiocb)) < 0)
    					err_sys("aio_return failed");
    				if (n != BSZ && !bufs[i].last)
    					err_quit("short read (%d/%d)", n, BSZ);
    				for (j = 0; j < n; j++)
    					bufs[i].data[j] = translate(bufs[i].data[j]);
    				bufs[i].op = WRITE_PENDING;
    				bufs[i].aiocb.aio_fildes = ofd;
    				bufs[i].aiocb.aio_nbytes = n;
    				if (aio_write(&bufs[i].aiocb) < 0)
    					err_sys("aio_write failed");
    				/* retain our spot in aiolist */
    				break;

    			case WRITE_PENDING:
    				if ((err = aio_error(&bufs[i].aiocb)) == EINPROGRESS)
    					continue;
    				if (err != 0) {
    					if (err == -1)
    						err_sys("aio_error failed");
    					else
    						err_exit(err, "write failed");
    				}

    				/*
    				 * A write is complete; mark the buffer as unused.
    				 */
    				if ((n = aio_return(&bufs[i].aiocb)) < 0)
    					err_sys("aio_return failed");
    				if (n != bufs[i].aiocb.aio_nbytes)
    					err_quit("short write (%d/%d)", n, BSZ);
    				aiolist[i] = NULL;
    				bufs[i].op = UNUSED;
    				numop--;
    				break;
    			}
    		}
    		if (numop == 0) {
    			if (off >= sbuf.st_size)
    				break;
    		} else {
    			if (aio_suspend(aiolist, NBUF, NULL) < 0)
    				err_sys("aio_suspend failed");
    		}
    	}

    	bufs[0].aiocb.aio_fildes = ofd;
    	if (aio_fsync(O_SYNC, &bufs[0].aiocb) < 0)
    		err_sys("aio_fsync failed");
    	exit(0);
    }

**异步IO可能会导致IO性能下降，因为系统的提前读失效**

# 多缓冲区读写，readv、writev

    #include <sys/uio.h>
    ssize_t readv(int fd, const struct iovec *iov, int iovcnt);
    ssize_t writev(int fd, const struct iovec *iov, int iovcnt);
    Both return: number of bytes read or written, −1 on error

内核需要将用户缓冲区拷贝到进程缓冲区

# 指定读写大小，readn、writen

    ssize_t readn(int fd, void *buf, size_t nbytes);
    ssize_t writen(int fd, void *buf, size_t nbytes);

#include "apue.h"

    ssize_t             /* Write "n" bytes to a descriptor  */
    writen(int fd, const void *ptr, size_t n)
    {
    	size_t		nleft;
    	ssize_t		nwritten;

    	nleft = n;
    	while (nleft > 0) {
    		if ((nwritten = write(fd, ptr, nleft)) < 0) {
    			if (nleft == n)
    				return(-1); /* error, return -1 */
    			else
    				break;      /* error, return amount written so far */
    		} else if (nwritten == 0) {
    			break;
    		}
    		nleft -= nwritten;
    		ptr   += nwritten;
    	}
    	return(n - nleft);      /* return >= 0 */
    }


# 存储映射IO

    void *mmap(void *addr, size_t len, int prot, int flag, int fd, off_t off );
    void *mmap2(void *addr, size_t length, int prot,int flags, int fd, off_t pgoffset);
    int mprotect(void *addr, size_t len, int prot);//修改映射权限
    int pkey_mprotect(void *addr, size_t len, int prot, int pkey);

返回映射区起始地址，若出错返回MAP_FAILED

addr指定映射区起始地址，设置为0表示由操作系统选择起始地址。

prot指定映射区保护要求
* PROT_READ  映射区可读
* PROT_WRITE 映射区可写
* PROT_EXEC 映射区可执行
* PROT_NOE 映射区不可访问

flag指定映射区属性

* MAP_FIXED 返回值必须等于addr，为了可移植，addr指定为0
* MAP_SHARED 指定存储操作修改映射文件，也就是操作内存就是操作该文件，不能喝MAP_PRIVATE同时指定
* MAP_PRIVATE 不能和MAP_SHARED同时指定，创建映射文件的一个私有副本，不会影响原文件。

**mmap和memcpy结合，是从内核缓冲区拷贝到另一个内核缓冲区，而read是内核缓冲区到用户缓冲区，write是用户缓冲区到内核缓冲区**

SIGSEGV表示进程试图访问不可用的存储区

SIGBUS 访问映射区不存在的部分

**子进程继承存储映射区，但是exec不继承**

## 冲刷存储映射

    int msync(void *addr, size_t len, int flags);

冲洗修改页到被映射的文件

flags：

* MS_ASYNC  立即返回，不等待冲洗操作完成。
* MS_SYNC 等待冲洗操作完成才返回

## 解除映射

    int munmap(void *addr, size_t len);

相关进程之间的存储映射，

* 读/dev/zero时，提供无限0字节资源，写此设备都被忽略
* 多个进程共同祖先对mmap指定了MAP_SHARED标志，这些进程可以共享此存储区
* 存储区初始化为0

## 存储映射间同步

    #include "apue.h"
    #include <fcntl.h>
    #include <sys/mman.h>

    #define	NLOOPS		1000
    #define	SIZE		sizeof(long)	/* size of shared memory area */

    static int
    update(long *ptr)
    {
    	return((*ptr)++);	/* return value before increment */
    }

    int
    main(void)
    {
    	int		fd, i, counter;
    	pid_t	pid;
    	void	*area;

    	if ((fd = open("/dev/zero", O_RDWR)) < 0)
    		err_sys("open error");
    	if ((area = mmap(0, SIZE, PROT_READ | PROT_WRITE, MAP_SHARED,
    	  fd, 0)) == MAP_FAILED)
    		err_sys("mmap error");
    	close(fd);		/* can close /dev/zero now that it's mapped */

    	TELL_WAIT();

    	if ((pid = fork()) < 0) {
    		err_sys("fork error");
    	} else if (pid > 0) {			/* parent */
    		for (i = 0; i < NLOOPS; i += 2) {
    			if ((counter = update((long *)area)) != i)
    				err_quit("parent: expected %d, got %d", i, counter);

    			TELL_CHILD(pid);
    			WAIT_CHILD();
    		}
    	} else {						/* child */
    		for (i = 1; i < NLOOPS + 1; i += 2) {
    			WAIT_PARENT();

    			if ((counter = update((long *)area)) != i)
    				err_quit("child: expected %d, got %d", i, counter);

    			TELL_PARENT(getppid());
    		}
    	}

    	exit(0);
    }


# 匿名存储映射

mmap指定MAP_ANON标志，并将文件描述符置为-1。此时不需要通过文件描述符和一个路径相结合。

    if ((area = mmap(0, SIZE, PROT_READ | PROT_WRITE, MAP_ANON | MAP_SHARED, -1, 0)) == MAP_FAILED)

# 文件访问模式设定

    int posix_fadvise(int fd, off_t offset, off_t len, int advice);

# 文件空间操作

    #include <fcntl.h>
    int fallocate(int fd, int mode, off_t offset, off_t len);
    int posix_fallocate(int fd, off_t offset, off_t len);

# 内存中创建一个匿名文件

    #include <sys/memfd.h>
    int memfd_create(const char *name, unsigned int flags);

# 文件缓冲冲洗控制

    #include <unistd.h>
    int fsync(int fd);
    int fdatasync(int fd);
    void sync(void);
    int syncfs(int fd);
    int sync_file_range(int fd, off64_t offset, off64_t nbytes, unsigned int flags);
    int msync(void *addr, size_t length, int flags);
    int sync_file_range(int fd, off64_t offset, off64_t nbytes, unsigned int flags);

* sync只将修改过的块缓冲区排入写队列，就返回，不等实际写磁盘操作结束，会更新文件系统属性。
* fsync函数只对fd关联文件起作用，会等待磁盘写操作结束后返回，同步更新文件属性。
* fdatasync类似fsync，但是只更新数据部分。
* syncfs和sync类似，但是不会更新文件系统属性
* sync_file_range可以精细化控制文件同步部分
* msync文件内存映射同步
