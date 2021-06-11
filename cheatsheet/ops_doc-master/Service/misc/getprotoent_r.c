#define _GNU_SOURCE
#include <ctype.h>
#include <netdb.h>
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>

#define MAX_BUF 10000

int
main(int argc, char *argv[])
{
    int buflen, erange_cnt, s;
    struct protoent result_buf;
    struct protoent *result;
    char buf[MAX_BUF];
    char **p;

    if (argc < 2) {
        printf("Usage: %s proto-name [buflen]\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    buflen = 1024;
    if (argc > 2)
        buflen = atoi(argv[2]);

    if (buflen > MAX_BUF) {
        printf("Exceeded buffer limit (%d)\n", MAX_BUF);
        exit(EXIT_FAILURE);
    }

    erange_cnt = 0;
    do {
        s = getprotobyname_r(argv[1], &result_buf,
                     buf, buflen, &result);
        if (s == ERANGE) {
            if (erange_cnt == 0)
        s = getprotobyname_r(argv[1], &result_buf,
                     buf, buflen, &result);
        if (s == ERANGE) {
            if (erange_cnt == 0)
                printf("ERANGE! Retrying with larger buffer\n");
            erange_cnt++;

            /* Increment a byte at a time so we can see exactly
               what size buffer was required */

            buflen++;

            if (buflen > MAX_BUF) {
                printf("Exceeded buffer limit (%d)\n", MAX_BUF);
                exit(EXIT_FAILURE);
            }
        }
    } while (s == ERANGE);

    printf("getprotobyname_r() returned: %s  (buflen=%d)\n",
            (s == 0) ? "0 (success)" : (s == ENOENT) ? "ENOENT" :
            strerror(s), buflen);

    if (s != 0 || result == NULL) {
        printf("Call failed/record not found\n");
        exit(EXIT_FAILURE);
    }

    printf("p_name=%s; p_proto=%d; aliases=",
                result_buf.p_name, result_buf.p_proto);
    for (p = result_buf.p_aliases; *p != NULL; p++)
        printf("%s ", *p);
    printf("\n");

    exit(EXIT_SUCCESS);
}

/*
$ ./a.out tcp 1
ERANGE! Retrying with larger buffer
getprotobyname_r() returned: 0 (success)  (buflen=78)
p_name=tcp; p_proto=6; aliases=TCP
$ ./a.out xxx 1
ERANGE! Retrying with larger buffer
getprotobyname_r() returned: 0 (success)  (buflen=100)
Call failed/record not found
*/