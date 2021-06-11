
#include <assert.h>
#include <stdio.h>
#include <string.h>
#include <getopt.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

#include "chunk-db.h"
#include "utils.h"
#include "zunkfs.h"

enum optype { INVALID, STORE, FIND };

enum {
    OPT_REQUIRED_ARG = ':',
    OPT_STORE = 's',
    OPT_FIND = 'f',
    OPT_DB = 'd',
    OPT_LOG = 'l',
};

static const char short_opts[] = {
    OPT_STORE,
    OPT_FIND,
    OPT_DB, OPT_REQUIRED_ARG,
    OPT_LOG, OPT_REQUIRED_ARG,
    0
};

static const struct option long_opts[] = {
    {"store", no_argument, NULL, OPT_STORE},
    {"find", no_argument, NULL, OPT_FIND},
    {"db", required_argument, NULL, OPT_DB},
    {"log", required_argument, NULL, OPT_LOG},
    {NULL}
};

#define USAGE \
"-s|--store                     Store chunk provided via stdin.\n"\
"-f|--find                      Find chunk matching digests on command line.\n"\
"-d|--db <chunk-db-spec>        Add a chunk-db\n"\
"-l|--log [level,]<file>        Enable logging of (E)rrors, (W)arnings,\n"\
"                               (T)races to a file. File can be a path,\n"\
"                               stdout, or stderr.\n"\
"\nChunk-db specs:\n"

static const char *prog;
static unsigned nr_dbs = 0;
static enum optype optype = INVALID;

static void usage (int exit_code) {
    fprintf (stderr, "Usage: %s [ options ]\n", prog);
    fprintf (stderr, "%s\n", USAGE);
    help_chunkdb ();
    exit (exit_code);
}

static int proc_opt (int opt, char *arg) {
    char *errstr;
    int err = 0;

    switch (opt) {
    case OPT_STORE:
        if (optype != INVALID) {
            fprintf (stderr, "Operation can be either store or find," " not both.\n");
            return -EINVAL;
        }
        optype = STORE;
        return 0;

    case OPT_FIND:
        if (optype != INVALID) {
            fprintf (stderr, "Operation can be either store or find," " not both.\n");
            return -EINVAL;
        }
        optype = FIND;
        return 0;

    case OPT_DB:
        errstr = add_chunkdb (arg);
        if (errstr) {
            fprintf (stderr, "Failed to add chunk-db %s: %s\n", optarg, STR_OR_ERROR (errstr));
            return err;
        }
        nr_dbs++;
        return 0;

    case OPT_LOG:
        err = set_logging (arg);
        if (err) {
            fprintf (stderr, "Failed to enable logging: %s\n", strerror (-err));
            return err;
        }
        return 0;

    default:
        return -1;
    }
}

static int do_store (int fd) {
    unsigned char chunk[CHUNK_SIZE] = { 0 };
    unsigned char digest[CHUNK_DIGEST_LEN];
    int err, n, size = 0;

    while (size < CHUNK_SIZE) {
        n = read (fd, chunk + size, CHUNK_SIZE - size);
        if (n < 0) {
            if (errno == EINTR)
                continue;
            fprintf (stderr, "read: %s\n", strerror (errno));
            exit (-1);
        }
        if (!n)
            break;
        size += n;
    }

    if (!size)
        return 0;

    err = write_chunk (chunk, digest);
    if (err < 0) {
        fprintf (stderr, "write_chunk: %s\n", strerror (-err));
        exit (-1);
    }

    printf ("Stored chunk %s\n", digest_string (digest));

    return 1;
}

static void do_find (const unsigned char *digest) {
    unsigned char chunk[CHUNK_SIZE] = { 0 };
    int err;

    err = read_chunk (chunk, digest);
    if (err < 0)
        fprintf (stderr, "read_chunk: %s\n", strerror (-err));

    else if (!verify_chunk (chunk, digest))
        fprintf (stderr, "Failed to verify received chunk.\n");

    else
        printf ("Found chunk %s\n", digest_string (digest));
}

int main (int argc, char **argv) {
    int opt, err;

    prog = argv[0];

    while ((opt = getopt_long (argc, argv, short_opts, long_opts, NULL))
           != -1) {
        err = proc_opt (opt, optarg);
        if (err)
            usage (err);
    }

    if (optype == INVALID) {
        fprintf (stderr, "Must specify store or find operation.\n\n");
        usage (-1);
    }

    if (!nr_dbs) {
        fprintf (stderr, "Must specify at least one chunk database." "\n\n");
        usage (-1);
    }

    if (optype == STORE) {
        if (optind == argc) {
            fprintf (stderr, "Must provide at least one file to " "store.\n");
            usage (-1);
        }
        for (; optind < argc; optind++) {
            int fd;

            fd = open (argv[optind], O_RDONLY);
            if (fd < 0) {
                fprintf (stderr, "Can't open %s: %s\n", argv[optind], strerror (errno));
                continue;
            }

            while (do_store (fd)) ;

            close (fd);
        }
    } else {
        if (optind == argc) {
            fprintf (stderr, "Must provide at least one digest to " "find.\n");
            usage (-1);
        }
        for (; optind < argc; optind++) {
            unsigned char digest[CHUNK_DIGEST_LEN];

            if (IS_ERR (__string_digest (argv[optind], digest))) {
                fprintf (stderr, "Invalid chunk digest: %s\n", argv[optind]);
                continue;
            }

            do_find (digest);
        }
    }

    return 0;
}
