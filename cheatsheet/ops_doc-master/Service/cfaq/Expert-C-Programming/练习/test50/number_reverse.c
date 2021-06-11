#include <stdio.h>

// 输入一个不超过五位的正整数，输出其逆数。例如输入12345，输出应为54321。
int reverse(int num){
    int ret = 0;
    while(num > 0){
        ret = ret * 10 + num % 10;
        num /= 10;
    }
    return ret;
}

int main(){
    int a = 12345;
    printf("%d\n", reverse(a));
    a = 45040;
    printf("%d\n", reverse(a));
    return 0;
}