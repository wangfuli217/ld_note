#include <stdio.h>

#define WARN_IF(EXP) \
    do{ \
        if (EXP) \
        fprintf(stderr, "Warning: " #EXP "\n");\
    }while(0)

int main(void) {
    int divider = 0;

    WARN_IF(divider == 0);

//  ���������佫չ��Ϊ��
//    do {
//      if (divider == 0)
//          fprintf(stderr, "Warning" "divider == 0" "/n");
//    } while(0);

    return 0;
}
