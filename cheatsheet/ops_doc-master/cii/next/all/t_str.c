#include<stdio.h>
#include<stdlib.h>
#include"str.h"

static
void
_usage()
{

    printf("Usage: str i j\n");
}

int
main(int argc, char *argv[])
{
    int i, j;
    char * str;
    ssize_t size;
    int bl;
    if(4 != argc){
        _usage();
    }

    i = atoi(argv[2]);
    j = atoi(argv[3]);

    str = str_sub(argv[1], i, j);
    printf("str_sub:%s\n", str);

    str = str_dup(argv[1], i, j, 3);
    printf("str_dup:%s\n", str);

    str = str_reverse(argv[1], i, j);
    printf("str_reverse:%s\n", str);

    str = str_cat(argv[1], i, j, "str_cat", 2, 4);
    printf("str_cat:%s\n", str);

    str = str_cat_v(argv[1], i, j, "str_cat", 1, -1, "str_cat_v", 1, -1, NULL);
    printf("str_cat_v:%s\n", str);

    str = str_map(argv[1], i, j, "abcdefg", "1234567");
    printf("str_map:%s\n", str);

    size = str_pos("wtf", -3);
    printf("str_pos:%zd\n", size);

    size = str_len(argv[1], i, j);
    printf("str_len:%zd\n", size);

    bl = str_cmp(argv[1], i, j, "warningc", i, j);
    printf("str_cmp:%d\n", bl);

    size = str_chr(argv[1], i, j, 'n');
    printf("str_chr c:%zd\n", size);

    size = str_rchr(argv[1], i, j, 'n');
    printf("str_rchr c:%zd\n", size);

    size = str_upto(argv[1], i, j, "cna");
    printf("str_upto c:%zd\n", size);

    size = str_rupto(argv[1], i, j, "cna");
    printf("str_rupto c:%zd\n", size);

    size = str_find(argv[1], i, j, "ing");
    printf("str_find c:%zd\n", size);

    size = str_rfind(argv[1], i, j, "ing");
    printf("str_rfind c:%zd\n", size);

    size = str_any(argv[1], i, "iwng");
    printf("str_any c:%zd\n", size);

    size = str_many(argv[1], i, j, "rwag");
    printf("str_many c:%zd\n", size);

    size = str_rmany(argv[1], i, j, "iwag");
    printf("str_rmany c:%zd\n", size);

    size = str_match(argv[1], i, j, ".jpg");
    printf("str_match c:%zd\n", size);

    size = str_rmatch(argv[1], i, j, ".jpg");
    printf("str_rmatch c:%zd\n", size);
    return 0;
}
