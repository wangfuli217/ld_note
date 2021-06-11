#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <sys/stat.h>

#include "cuckoo_filter.h"
#include "sha1.h"

int main(int argc, char **argv)
{
        SHA_CTX c;
        struct stat st;
        uint32_t key_num;
        uint8_t *keys;
        uint8_t **sha1_key;
        uint8_t value[DAT_LEN], *v;
        int bytes, i, j;
        FILE *f1, *f2;

        if (argc < 3) {
                fprintf(stderr, "usage: ./cuckoo_filter read_file write_file\n");
                exit(-1);
        }

        --argc;
        ++argv;

        f1 = fopen(argv[0], "rb");
        if (f1 == NULL) {
                fprintf(stderr, "Fail to open %s!\n", argv[0]);
                exit(-1);
        }
        stat(argv[0], &st);

        f2 = fopen(argv[1], "wb+");
        if (f2 == NULL) {
                fprintf(stderr, "Fail to open %s!\n", argv[1]);
                exit(-1);
        }

        /* Initialization */
        cuckoo_filter_init(st.st_size);

        /* Allocate SHA1 key space */
        key_num = next_pow_of_2(st.st_size) / DAT_LEN;
        keys = malloc(key_num * 20);
        sha1_key = malloc(key_num * sizeof(void *));
        if (!keys || !sha1_key) {
                fprintf(stderr, "Out of memory!\n");
                exit(-1);
        }
        for (i = 0; i < key_num; i++) {
                sha1_key[i] = keys + i * 20;
        }

        /* Put read_file into log on flash. */
        i = 0;
        do {
                memset(value, 0, DAT_LEN);
                bytes = fread(value, 1, DAT_LEN, f1);
                SHA1_Init(&c);
                SHA1_Update(&c, value, bytes);
                SHA1_Final(sha1_key[i], &c);
                cuckoo_filter_put(sha1_key[i], value);
                i++;
        } while (bytes == DAT_LEN);

        /* Real key number */
        key_num = i;
        printf("Total %u records.\n", key_num);

        /* Deletion test */
        for (i = 0; i < key_num; i += 2) {
                cuckoo_filter_put(sha1_key[i], NULL);
        }

        fseek(f1, 0, SEEK_SET);
        for (i = 0; i < key_num; i++) {
                memset(value, 0, DAT_LEN);
                bytes = fread(value, 1, DAT_LEN, f1);
                if (!(i & 0x1)) {
                        cuckoo_filter_put(sha1_key[i], value);
                }
        }

        /* Get logs on flash and write them into a new file. */
        for (j = 0; j < key_num; j++) {
                v = cuckoo_filter_get(sha1_key[j]);
                if (v != NULL) {
                        memcpy(value, v, DAT_LEN);
                        fwrite(value, 1, DAT_LEN, f2);
                }
        }

        fclose(f1);
        fclose(f2);

        free(keys);
        free(sha1_key);

        return 0;
}
