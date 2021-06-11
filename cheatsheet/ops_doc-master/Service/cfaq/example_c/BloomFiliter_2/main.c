#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>
#include <string.h>

#include "hashes.h"
#include "bloom.h"

#define NUM_STRINGS 8

const char *STR[]={
        "Howdy, partner.",
        "Stick some strings in there.",
        "Does it match? The future is cloudy.",
        "Bloomers",
        "Non-tropical storms.",
        "/\\//\\/////\\/$^2*/@!5s0ElieeiTEd[]()d",
        "Cartouche de Donnees.",
        "This is a test of the Bloom filter."
};


int main(int argc, char *argv[]) 
{
        struct bloom_t *bloom;
        int nstrings = 8;
        int i;

        if (argc < 2) {
                printf("You have to argue a string...\n");
                exit(0);
        }

        bloom = bloom_new(2500000, 4, fnv_hash, sax_hash, sdbm_hash, djb2_hash);

        printf("Testing Bloom filter.\n\n");
        printf("m: %zd\nk: %zd\n\n", bloom->m, bloom->k);

        for (i=0; i < nstrings; i++) {
                bloom_add(bloom, STR[i]);
                printf("Added \"%s\"\n", STR[i]);
        }

        if (bloom_check(bloom, argv[1]))
                printf("\nString: \"%s\" is probably in the filter.\n", argv[1]);
        else
                printf("\nString: \"%s\" is not in the filter.\n", argv[1]);

        bloom_del(bloom);

        printf("\nAll done!\n");
		
#if defined(__WIN32)
		system("pause");
#endif

        return 0;
}
