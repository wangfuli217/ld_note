/* core_pattern_pipe_test.c */

#define _GNU_SOURCE
#include <sys/stat.h>
#include <fcntl.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define BUF_SIZE 1024

int
main(int argc, char *argv[])
{
    int tot, j;
    ssize_t nread;
    char buf[BUF_SIZE];
    FILE *fp;
    char cwd[PATH_MAX];

    /* Change our current working directory to that of the
       crashing process */

    snprintf(cwd, PATH_MAX, "/proc/%s/cwd", argv[1]);
    chdir(cwd);

    /* Write output to file "core.info" in that directory */

    fp = fopen("core.info", "w+");
    if (fp == NULL)
        exit(EXIT_FAILURE);

    /* Display command-line arguments given to core_pattern
       pipe program */

    fprintf(fp, "argc=%d\n", argc);
    for (j = 0; j < argc; j++)
        fprintf(fp, "argc[%d]=<%s>\n", j, argv[j]);

    /* Count bytes in standard input (the core dump) */
    tot = 0;
    while ((nread = read(STDIN_FILENO, buf, BUF_SIZE)) > 0)
        tot += nread;
    fprintf(fp, "Total bytes in core dump: %d\n", tot);

    exit(EXIT_SUCCESS);
}

/*
$ cc -o core_pattern_pipe_test core_pattern_pipe_test.c
$ su
Password:
# echo '|$PWD/core_pattern_pipe_test %p UID=%u GID=%g sig=%s' > \
   /proc/sys/kernel/core_pattern
# exit
$ sleep 100
^\                     # type control-backslash
Quit (core dumped)
$ cat core.info
argc=5
argc[0]=</home/mtk/core_pattern_pipe_test>
argc[1]=<20575>
argc[2]=<UID=1000>
argc[3]=<GID=100>
argc[4]=<sig=3>
Total bytes in core dump: 282624
*/