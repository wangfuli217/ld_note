#include <stdio.h>

#define TEST2($M,$N)\
    do{ \
        printf("_$$$LN = %d\n", _$$$LN);\
        printf("$M = %d, $N = %d\n", $M,$N);\
        printf("$M = %s\n", $M);\
    }while(0);

#define TEST($M,$N) \
        do{ \
                int _$$$LN = 100;\
                TEST2($M,$N);\
        }while(0);

int main(void) {
    int $$ = 110;

    printf("$$ = %d\n", $$);
    TEST(1,2);
    return 0;
}
