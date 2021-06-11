#include <stdio.h>

// 输入1~10之间的一个数字，输出它对应的英文单词。
const char* mapper(int digit){
    if(digit < 0 || digit > 10) return NULL;
    static char *arr[] = {"zero", "one", "two",
                          "three", "four", "five",
                          "six", "seven", "eight",
                          "nine", "ten" };
    return arr[digit];
}

int main(){
    int i;
    for(i = 1; i <= 10; i++){
        printf("%d : %s\n", i, mapper(i));
    }
    return 0;
}