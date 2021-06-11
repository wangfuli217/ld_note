#include <malloc.h>
#include <stdio.h>
#include <string.h>

int main(){
    char *letter = strdup("ABCDEF");
    memcpy(&letter[2], letter, strlen(letter)+1);
    printf("%s\n", &letter[2]); /* ABABAF */

    char *letter2 = strdup("ABCDEF");
    memcpy(&letter2[-2], letter2, strlen(letter2)+1);
    printf("%s\n", &letter2[-2]); /* ABCDEF */

    char *letter3 = strdup("ABCDEF");
    memmove(&letter3[2], letter3, strlen(letter3)+1);
    printf("%s\n", &letter3[2]); /* ABCDEF */
}

/*
memcpy将使用暴力复制，每次拷贝4个字节，它 不会检查目标与源地址重叠 问题，当源地址
在目标地址之前，容易出问题，目标地址在源地址之前，则能正常工作，但memmove就没有问题，
但性能稍降低。当确信没有重叠时，优先使用memcpy
*/