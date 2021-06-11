       #include <stdio.h>
       #include <stdlib.h>
#include <fmtmsg.h>

int
main(void)
{
    long class = MM_PRINT | MM_SOFT | MM_OPSYS | MM_RECOVER;
    int err;

    err = fmtmsg(class, "util-linux:mount", MM_ERROR,
                "unknown mount option", "See mount(8).",
                "util-linux:mount:017");
    switch (err) {
    case MM_OK:
        break;
    case MM_NOTOK:
        printf("Nothing printed\n");
        break;
    case MM_NOMSG:
        printf("Nothing printed to stderr\n");
        break;
    case MM_NOCON:
        printf("No console output\n");
        break;
    default:
        printf("Unknown error from fmtmsg()\n");
    }
    exit(EXIT_SUCCESS);
}