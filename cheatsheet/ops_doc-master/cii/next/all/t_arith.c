#include<stdio.h>
#include"arith.h"

int
main(int argc, char *argv[])
{
    int ret;

    ret = arith_max(3, 5);

    printf("arith_max(3, 5)=%d\n", ret);
}
