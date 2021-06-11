
#define _GNU_SOURCE
#include <assert.h>
#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
#include <limits.h>
#include <pthread.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <libgen.h>

#include <sys/stat.h>
#include <sys/time.h>
#include <sys/types.h>

#include "zunkfs.h"
#include "zunkfs-tests.h"
#include "utils.h"
#include "file.h"
#include "dir.h"
#include "chunk-db.h"

static const char spaces[] = "                                                                                                                                                               ";
#define indent_start (spaces + sizeof(spaces) - 1)

void test_import (char *path) {
    off_t offset;
    int fd, err;
    struct open_file *ofile;
    struct timeval start, end, delta;
    struct stat stbuf;

    gettimeofday (&start, NULL);

    fd = open (path, O_RDONLY);
    if (fd < 0) {
        if (errno == EPERM)
            return;
        if (errno == EACCES)
            return;
        panic ("open %s: (%d) %s\n", path, errno, strerror (errno));
    }

    if (fstat (fd, &stbuf)) {
        close (fd);
        return;
    }

    if (!S_ISREG (stbuf.st_mode)) {
        close (fd);
        return;
    }

    fprintf (stderr, "importing %s\n", path);

    ofile = create_file (basename (path), 0700 | S_IFREG);
    if (IS_ERR (ofile))
        panic ("create_file: %s\n", strerror (PTR_ERR (ofile)));

    for (offset = 0;;) {
        char buf[4096];
        int n, m;
      read_again:
        n = read (fd, buf, sizeof (buf));
        if (n < 0) {
            if (errno != EINTR)
                panic ("read %s: %s\n", path, strerror (errno));
            goto read_again;
        }
        if (!n)
            break;

      write_again:
        m = write_file (ofile, buf, n, offset);
        if (m < 0) {
            if (errno != EINTR)
                panic ("write: %s\n", strerror (-m));
            goto write_again;
        }

        assert (m == n);
        offset += m;
    }

    err = flush_file (ofile);
    if (err < 0)
        panic ("flush_file: %s\n", strerror (-err));

    err = close_file (ofile);
    if (err < 0)
        panic ("close_file: %s\n", strerror (-err));

    ofile = open_file (basename (path));
    if (IS_ERR (ofile))
        panic ("open_file: %s\n", strerror (-err));

    gettimeofday (&end, NULL);
    timersub (&end, &start, &delta);
    start = end;

    printf ("time to import: %lu.%06lu\n", (unsigned long) delta.tv_sec, (unsigned long) delta.tv_usec);

    fprintf (stderr, "verifying...\n");
    err = lseek (fd, 0, SEEK_SET);
    assert (err == 0);
    for (offset = 0;;) {
        char buf[4096];
        char buf2[4096];
        int n, m;

        memset (buf, 0, sizeof (buf));
        memset (buf2, 0, sizeof (buf2));
      read_again2:
        n = read (fd, buf, sizeof (buf));
        if (n < 0) {
            if (errno != EINTR)
                panic ("read %s: %s\n", path, strerror (errno));
            goto read_again2;
        }
        if (!n)
            break;

      read_again3:
        m = read_file (ofile, buf2, n, offset);
        if (m < 0) {
            if (errno != EINTR)
                panic ("write: %s\n", strerror (-m));
            goto read_again3;
        }

        assert (m == n);
        assert (!memcmp (buf, buf2, n));
        offset += m;
    }

    printf ("size=%" PRIu64 " nr_leafs=%u height=%u\n", file_dentry (ofile)->size, file_dentry (ofile)->chunk_tree.nr_leafs, file_dentry (ofile)->chunk_tree.height);

    err = close_file (ofile);
    if (err < 0)
        panic ("close_file: %s\n", strerror (-err));

    close (fd);

    gettimeofday (&end, NULL);
    timersub (&end, &start, &delta);

    printf ("time to verify: %lu.%06lu\n", (unsigned long) delta.tv_sec, (unsigned long) delta.tv_usec);
}

int main (int argc, char **argv) {
    struct disk_dentry root_ddent;
    DECLARE_MUTEX (root_mutex);
    char *errstr;
    int i, err;

    err = set_logging ("T,stdout");
    if (err)
        panic ("set_logging: %s\n", strerror (-err));

    errstr = add_chunkdb ("rw,mem:");
    if (errstr)
        panic ("add_chunkdb: %s\n", STR_OR_ERROR (errstr));

    err = init_disk_dentry (&root_ddent);
    if (err < 0)
        panic ("init_disk_dentry: %s\n", strerror (-err));

    namcpy (root_ddent.name, "/");

    root_ddent.mode = htole16 (S_IFDIR | S_IRWXU);
    root_ddent.size = htole64 (0);
    root_ddent.ctime = htole32 (time (NULL));
    root_ddent.mtime = htole32 (time (NULL));

    err = set_root (&root_ddent, &root_mutex);
    if (err)
        panic ("set_root: %s\n", strerror (-err));

    for (i = 1; i < argc; i++)
        test_import (argv[i]);

    return 0;
}
