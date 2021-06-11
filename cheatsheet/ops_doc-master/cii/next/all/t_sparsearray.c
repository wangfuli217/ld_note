#include<stdio.h>
#include<limits.h>
#include"sparsearray.h"

#define TEST_MAX INT_MAX
#define SPAN 65535

double
per(int cur, int total)
{
    return ((double)cur/(double)total) * 100.0;
}

int
main(int argc, char *argv[])
{
    sparsearray_t sarray;
    ssize_t index, length;
    double percent, cur;

    sarray = sparsearray_new(TEST_MAX);

    printf("-1 INT_MAX = %d\n", INT_MAX);

    printf("0 length of sarray:%zd\n", sparsearray_length(sarray));

    percent = 0.0;
    for(index = 1; index < TEST_MAX; index++){

        if(0 == index % SPAN){
            sparsearray_put(sarray, index, (void *)index);
            
            cur = per(index, TEST_MAX);
            if(cur - percent > 1.0){
                percent = cur;
                printf("put per:%f\n", percent);
            }
        }
    }

    printf("1 length of sarray:%zd\n", sparsearray_length(sarray));

    printf("2 value of 77777:%ld\n", (long)sparsearray_get(sarray, 77777));


    length = sparsearray_length(sarray);
    printf("3 value of pos:%zd = %ld\n", length-1, (long)sparsearray_get_at(sarray, length-1));

    printf("4 value of key:%d = %ld\n", TEST_MAX-5, (long)sparsearray_get(sarray, TEST_MAX-5));
}
