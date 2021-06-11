// 输入一个字串，判断它是否是对称串。如”abcdcba”是对称串，”123456789”不是。
#include <stdio.h>
#include <string.h>

int check(char *str){
    int len = strlen(str);
    int i = 0;
    while(i < len/2){
        if(str[i] != str[len-1-i]) return 0;
        i++;
    }
    return 1;
}
int main(void){
    printf("%d\n", check("abcdcba"));
    printf("%d\n", check("123456789"));
    printf("%d\n", check("abccba"));
    printf("%d\n", check("abbccbba"));
    return 0;
}