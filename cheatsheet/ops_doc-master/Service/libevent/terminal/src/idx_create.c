/***
 * this is for idx generate
 */
#include <unistd.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "hdict.h"
#include "util.h"
#include "crc64.h"

static void usage(void) {
    printf("-i     <input path>    the raw file path for generate idx\n"
        "-o     <output path>   generated idx file path\n"
        "-h                     help\n"
        "-s                     string keys\n"
        "-l     <label>         idx label\n"
        "-n     <key num>       just for string keys,you must specify the num for string keys\n"
        "-t     <idx type>      0:the idx key is integer,idx with binary search. 1:idx key is string, idx with hash\n");
    return;
}

static int find_index(const char* str, char c){
    int index = 0;
    while(*str){
        if(c == *str){
            return index;
        }
        index++;
        str++;
    }
    return -1;
}

static int cmp_idx_key(const void* p1, const void* p2)
{
    uint64_t key1 = ((idx_t*)p1)->key;
    uint64_t key2 = ((idx_t*)p2)->key;

    return key1 >= key2 ? 1 : -1;
}

int main(int argc, char* argv[]){
    int c;
    char *input, *output;
    uint8_t idx_type = 1;
    char* label;
    int line_num = 0;
    char buf[4096];
    int index;
    while ((c = getopt(argc, argv, "i:o:hsl:i:n:")) != -1) {
        switch (c) {
        case 'i':
            input = optarg;
            break;
        case 'n':
            line_num = atoi(optarg);
            break;
        case 'o':
            output = optarg;
            break;
        case 'l':
            label = optarg;
            break;
        case 'h':
            usage();
            exit(EXIT_SUCCESS);
        case 's':                   //type 1 for integer key, type 2 for string key
            idx_type = 2;
            break;
        default:
            fprintf(stderr, "Illegal argument \"%c\"\n", c);
            return 1;
        }
    }
    if (NULL == input || NULL == output || NULL == label){
        usage();
        exit(EXIT_SUCCESS);
    }
    if (idx_type == 2 && line_num <= 0){
        fprintf(stderr, "Please set the line num\n");
        exit(EXIT_SUCCESS);
    }
    //write the meta head
    meta_t idx_meta;
    idx_meta.version = time(NULL);
    idx_meta.idx_type = idx_type;
    strcpy(idx_meta.label, label);
    uint64_t crc = crc64(0, &idx_meta, sizeof(meta_t));
    FILE *out_fp = fopen(output, "wb");
    if (NULL == out_fp){
        fprintf(stderr, "Illegal Output file %s\n", output);
        return 1;
    }

    fprintf(stderr, "version:%u idx_type:%d label:%s crc:%lu\n", idx_meta.version, idx_meta.idx_type, idx_meta.label, crc);
    fwrite(&idx_meta, sizeof(idx_meta), 1, out_fp);
    fwrite(&crc, sizeof(uint64_t), 1, out_fp);

    FILE *in_fp;
    uint64_t hash_key;
    long off;
    int pos;

    in_fp = fopen(input, "r");
    if (NULL == in_fp){
        fprintf(stderr, "Illegal Input file %s\n", input);
        return 1;
    }
    off = ftell(in_fp);
    if(idx_type == 2){
        //get the prime
        idx_t *idx_hash = (idx_t *)calloc(line_num, sizeof(idx_t));
        assert(idx_hash != NULL);
        off = ftell(in_fp);
        pos = 0;
        size_t len;
        while(fgets(buf, 4096, in_fp) != NULL){
            index = find_index(buf, ':');
            if (index == -1){
                continue;
            }
            len = strlen(buf);
            buf[index] = '\0';
            //string hash
            hash_key = bkdr_hash(buf);
            idx_hash[pos].key = hash_key;
            idx_hash[pos].pos = (len << 40) | off;
            off = ftell(in_fp);
            pos++;
        }
        qsort(idx_hash, line_num, sizeof(idx_t), cmp_idx_key);
        fprintf(stderr, "sort finish\n");
        fwrite(idx_hash, sizeof(idx_t), line_num, out_fp);
    }else{
        idx_t idx_data;
        while(fgets(buf, 4096, in_fp) != NULL){
            index = find_index(buf, ':');
            if (index == -1){
                continue;
            }
            idx_data.key = strtoull(buf, NULL, 10);
            off = off + index + 1;
            idx_data.key = strtoull(buf, NULL, 10);
            idx_data.pos = ((strlen(buf) - index - 1) << 40) | off;
            fwrite(&idx_data, sizeof(idx_t), 1, out_fp);
            off = ftell(in_fp);
        }
    }
    fclose(out_fp);
    fclose(in_fp);
    return 0;
}
