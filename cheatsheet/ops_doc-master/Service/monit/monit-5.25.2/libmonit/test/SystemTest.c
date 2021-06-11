#include "Config.h"

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include <errno.h>
#include <sys/types.h>
#include <signal.h>
#include <unistd.h>
#include <stdarg.h>
#include <inttypes.h>

#include "Bootstrap.h"
#include "Str.h"
#include "system/System.h"
#include "system/Time.h"
#include "Thread.h"

/**
 * System.c unity tests.
 */



int main(void) {

        Bootstrap(); // Need to initialize library

        printf("============> Start System Tests\n\n");

        printf("=> Test0: check error description\n");
        {
                const char *error = System_getError(EINVAL);
                assert(error != NULL);
                printf("\tEINVAL description: %s\n", error);
                errno = EINVAL;
                assert(Str_isEqual(System_getLastError(), error));

        }
        printf("=> Test0: OK\n\n");

        printf("=> Test1: check filedescriptors wrapper\n");
        {
                assert(System_getDescriptorsGuarded() <= 2<<15);

        }
        printf("=> Test1: OK\n\n");

        printf("=> Test2: random data generator\n");
        {
                srandom((unsigned)(Time_now() + getpid()));
                //
                printf("\tnumber:   %"PRIx64"\n", System_randomNumber());
                //
                printf("\t1  byte:  ");
                char buf0[1];
                assert(System_random(buf0, sizeof(buf0)));
                for (int i = 0; i < sizeof(buf0); i++) {
                        printf("%x", buf0[i]);
                }
                printf("\n");
                //
                printf("\t4  bytes: ");
                char buf1[4];
                assert(System_random(buf1, sizeof(buf1)));
                for (int i = 0; i < sizeof(buf1); i++) {
                        printf("%x", buf1[i]);
                }
                printf("\n");
                //
                printf("\t16 bytes: ");
                char buf2[16];
                assert(System_random(buf2, sizeof(buf2)));
                for (int i = 0; i < sizeof(buf2); i++) {
                        printf("%x", buf2[i]);
                }
                printf("\n");
                //
                assert(System_randomNumber() != System_randomNumber());
        }
        printf("=> Test1: OK\n\n");

        printf("============> System Tests: OK\n\n");

        return 0;
}
