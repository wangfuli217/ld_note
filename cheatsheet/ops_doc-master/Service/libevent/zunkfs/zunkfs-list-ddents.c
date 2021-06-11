
#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
#include <libgen.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <getopt.h>

#include <sys/types.h>
#include <sys/stat.h>

#include "zunkfs.h"
#include "chunk-db.h"
#include "dir.h"

static unsigned full_output = 0;

enum {
    OPT_REQUIRED_ARG = ':',
    OPT_CHUNK_DB = 'd',
    OPT_LOG = 'l',
    OPT_FULL = 'f',
    OPT_HELP = 'h'
};

static const char short_opts[] = {
    OPT_CHUNK_DB, OPT_REQUIRED_ARG,
    OPT_LOG, OPT_REQUIRED_ARG,
    OPT_FULL,
    OPT_HELP,
    0
};

static const struct option long_opts[] = {
    {"chunk-db", required_argument, NULL, OPT_CHUNK_DB},
    {"log", required_argument, NULL, OPT_LOG},
    {"full", no_argument, NULL, OPT_FULL},
    {"help", no_argument, NULL, OPT_HELP},
    {NULL}
};

#define USAGE \
"-h|--help\n"\
"-d|--chunk-db <dbspec>                   Chunk database.\n"\
"-l|--log [<E|W|T>,]<file|stdout|stderr>  Log: Error, Warning, Trace.\n"\
"-f|--full                                Full output\n"

static const char *prog;

static void usage (int exit_code) {
    fprintf (stderr, "Usage: %s [ options ]\n%s\n", prog, USAGE);
    exit (exit_code);
}

static void proc_opt (int opt, char *arg) {
    char *errstr;
    int err;

    switch (opt) {
    case OPT_HELP:
        usage (0);
    case OPT_CHUNK_DB:
        errstr = add_chunkdb (arg);
        if (errstr) {
            fprintf (stderr, "Failed to add chunkdb %s: %s\n", arg, STR_OR_ERROR (errstr));
            exit (-2);
        }
        break;

    case OPT_LOG:
        err = set_logging (arg);
        if (err) {
            fprintf (stderr, "Failed to enable logging: %s\n", strerror (-err));
            exit (-2);
        }
        break;
    case OPT_FULL:
        full_output = 1;
        break;
    default:
        usage (-1);
    }
}

static int read_dentry (int fd, struct disk_dentry *de) {
    void *ptr = de;
    int len;

    for (len = 0; len < sizeof (struct disk_dentry);) {
        int n = read (fd, ptr + len, sizeof (struct disk_dentry) - len);
        if (n < 0) {
            if (errno == EINTR)
                continue;
            return -errno;
        }
        if (!n)
            break;
        len += n;
    }

    return len;
}

int main (int argc, char **argv) {
    const char *crypto;
    char cwd[1024];
    int fd, opt;

    prog = basename (argv[0]);

    getcwd (cwd, 1024);

    while ((opt = getopt_long (argc, argv, short_opts, long_opts, NULL))
           != -1)
        proc_opt (opt, optarg);

    if (argc != optind)
        usage (-1);

    fd = open (DIR_AS_FILE, O_RDONLY);
    if (fd < 0) {
        fprintf (stderr, "Can't open %s/%s: %s\n", cwd, DIR_AS_FILE, strerror (errno));
        exit (-2);
    }

    for (;;) {
        struct disk_dentry dentry;
        int err = read_dentry (fd, &dentry);
        if (err < 0) {
            fprintf (stderr, "read_dentry: %s\n", strerror (errno));
            exit (-3);
        }
        if (!err)
            break;

        if ((dentry.flags & DDENT_USE_BLOWFISH))
            crypto = "blowfish";
        else
            crypto = "xor";

        if (full_output) {
            printf ("%s %s 0%0o %" PRIu64 " %u %u %s %s\n",
                    digest_string (dentry.digest),
                    digest_string (dentry.secret_digest), le16toh (dentry.mode), le64toh (dentry.size), le32toh (dentry.ctime), le32toh (dentry.mtime), crypto, dentry.name);
        } else {
            printf ("%s %s %" PRIu64 " %s %s\n", digest_string (dentry.digest), digest_string (dentry.secret_digest), le64toh (dentry.size), crypto, dentry.name);
        }
    }

    close (fd);
    return 0;
}
