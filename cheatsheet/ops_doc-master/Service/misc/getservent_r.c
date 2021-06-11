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
    int buflen, erange_cnt, port, s;
    struct servent result_buf;
    struct servent *result;
    char buf[MAX_BUF];
    char *protop;
    char **p;

    if (argc < 3) {
        printf("Usage: %s port-num proto-name [buflen]\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    port = htons(atoi(argv[1]));
    protop = (strcmp(argv[2], "null") == 0 ||
           strcmp(argv[2], "NULL") == 0) ?  NULL : argv[2];

    buflen = 1024;
    if (argc > 3)
        buflen = atoi(argv[3]);

    if (buflen > MAX_BUF) {
        printf("Exceeded buffer limit (%d)\n", MAX_BUF);
        exit(EXIT_FAILURE);
    }

    erange_cnt = 0;
    do {
        s = getservbyport_r(port, protop, &result_buf,
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

    printf("getservbyport_r() returned: %s  (buflen=%d)\n",
            (s == 0) ? "0 (success)" : (s == ENOENT) ? "ENOENT" :
            strerror(s), buflen);

    if (s != 0 || result == NULL) {
        printf("Call failed/record not found\n");
        exit(EXIT_FAILURE);
    }

    printf("s_name=%s; s_proto=%s; s_port=%d; aliases=",
                result_buf.s_name, result_buf.s_proto,
                ntohs(result_buf.s_port));
    for (p = result_buf.s_aliases; *p != NULL; p++)
        printf("%s ", *p);
    printf("\n");

    exit(EXIT_SUCCESS);
}

/*
$ ./a.out 7 tcp 1
ERANGE! Retrying with larger buffer
getservbyport_r() returned: 0 (success)  (buflen=87)
s_name=echo; s_proto=tcp; s_port=7; aliases=
$ ./a.out 77777 tcp
getservbyport_r() returned: 0 (success)  (buflen=1024)
Call failed/record not found
*/