#define _XOPEN_SOURCE
#include <unistd.h>
#include <stdlib.h>

int
main(void)
{
    char key[64];      /* bit pattern for key */
    char txt[64];      /* bit pattern for messages */

    setkey(key);
    encrypt(txt, 0);   /* encode */
    encrypt(txt, 1);   /* decode */
}