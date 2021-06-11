#include<stdio.h>
#include"bit.h"

int
main(int argc, char *argv[])
{
    bit_t bit, sit, union_set, inter_set, minus_set, diff_set;
    long tmp, i;

    bit = bit_new(2048);
    sit = bit_new(2048);

    for(i = 64; i < 128; i++){
        bit_put(bit, i, 1);
    }
    printf("1 bit count:%zd\n", bit_count(bit));

    for(i = 64; i < 128; i++){
        bit_put(bit, i, 0);
    }
    printf("2 bit count:%zd\n", bit_count(bit));

    for(i = 64; i < 128; i++){
        bit_put(bit, i, 1);
    }
    printf("3 bit count:%zd\n", bit_count(bit));
    
    bit_not(bit, 64, 128);
    printf("4 bit count:%zd\n", bit_count(bit));

    bit_set(bit, 64, 127);
    printf("5 bit count:%zd\n", bit_count(bit));

    bit_not(bit, 64, 127);
    printf("6 bit count:%zd\n", bit_count(bit));

    for(i = 64; i < 128; i++){
        bit_put(bit, i, 1);
    }
    printf("7 bit count:%zd\n", bit_count(bit));
    
    bit_not(bit, 64, 128);
    printf("8 bit count:%zd\n", bit_count(bit));


    for(i = 64; i < 128; i++){
        bit_put(bit, i, 1);
    }
    printf("9 bit count:%zd\n", bit_count(bit));

    bit_put(sit, 64, 1);
    printf("10 sit eq bit:%d\n", bit_eq(sit,bit));
    printf("11 sit lt bit:%d\n", bit_lt(sit, bit));
    printf("12 sit leq bit:%d\n", bit_leq(sit, bit));


    bit_put(sit, 63, 1);
    union_set = bit_union(bit, sit);
    inter_set = bit_inter(bit, sit);
    minus_set = bit_minus(bit, sit);
    diff_set  = bit_diff(bit, sit);

    printf("13 union_set count:%zd\n", bit_count(union_set));
    printf("14 inter_set count:%zd\n", bit_count(inter_set));
    printf("15 minus_set count:%zd\n", bit_count(minus_set));
    printf("16 diff_set count:%zd\n", bit_count(diff_set));
}
