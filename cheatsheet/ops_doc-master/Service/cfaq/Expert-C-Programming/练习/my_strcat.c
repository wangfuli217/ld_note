#include <stdio.h>
#define ARR_SIZE 20

char* my_strcat(char*, char*);
int main(){
    char str1[ARR_SIZE] = "abcd";
    char* str2 = "012345";
    printf("%s", my_strcat(str1, str2));
    return 0;
}

char* my_strcat(char *str1, char *str2){
    char* p = str1, *q = str2;
    while(*p != '\0') p++;
    while(*q != '\0'){
        *p++ = *q++;
    }
    *p = '\0';
    return str1;
}