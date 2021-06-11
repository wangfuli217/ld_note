#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

int
main(int argc, char *argv[])
{
#ifdef _POSIX_SOURCE
    printf("_POSIX_SOURCE defined\n");
#endif

#ifdef _POSIX_C_SOURCE
    printf("_POSIX_C_SOURCE defined: %ldL\n", (long) _POSIX_C_SOURCE);
#endif

#ifdef _ISOC99_SOURCE
    printf("_ISOC99_SOURCE defined\n");
#endif

#ifdef _XOPEN_SOURCE
    printf("_XOPEN_SOURCE defined: %d\n", _XOPEN_SOURCE);
#endif

#ifdef _XOPEN_SOURCE_EXTENDED
    printf("_XOPEN_SOURCE_EXTENDED defined\n");
#endif

#ifdef _LARGEFILE64_SOURCE
    printf("_LARGEFILE64_SOURCE defined\n");
#endif

#ifdef _FILE_OFFSET_BITS
    printf("_FILE_OFFSET_BITS defined: %d\n", _FILE_OFFSET_BITS);
#endif

#ifdef _BSD_SOURCE
    printf("_BSD_SOURCE defined\n");
#endif

#ifdef _SVID_SOURCE
    printf("_SVID_SOURCE defined\n");
#endif

#ifdef _ATFILE_SOURCE
    printf("_ATFILE_SOURCE defined\n");
#endif

#ifdef _GNU_SOURCE
    printf("_GNU_SOURCE defined\n");
#endif

#ifdef _REENTRANT
    printf("_REENTRANT defined\n");
#endif

#ifdef _THREAD_SAFE
    printf("_THREAD_SAFE defined\n");
#endif

#ifdef _FORTIFY_SOURCE
    printf("_FORTIFY_SOURCE defined\n");
#endif

    exit(EXIT_SUCCESS);
}

/*
$ cc ftm.c
$ ./a.out
_POSIX_SOURCE defined
_POSIX_C_SOURCE defined: 200809L
_BSD_SOURCE defined
_SVID_SOURCE defined
_ATFILE_SOURCE defined
$ cc -D_XOPEN_SOURCE=500 ftm.c
$ ./a.out
_POSIX_SOURCE defined
_POSIX_C_SOURCE defined: 199506L
_XOPEN_SOURCE defined: 500
$ cc -D_GNU_SOURCE ftm.c
$ ./a.out
_POSIX_SOURCE defined
_POSIX_C_SOURCE defined: 200809L
_ISOC99_SOURCE defined
_XOPEN_SOURCE defined: 700
_XOPEN_SOURCE_EXTENDED defined
_LARGEFILE64_SOURCE defined
_BSD_SOURCE defined
_SVID_SOURCE defined
_ATFILE_SOURCE defined
_GNU_SOURCE defined
*/