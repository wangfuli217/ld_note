#include <stdio.h>

// 从终端输入三个正实数，判断这三个数能否构成直角三角形。
int check(int a, int b, int c){
    int square_a = a * a;
    int square_b = b * b;
    int square_c = c * c;
    if(square_a == square_b + square_c) return 1;
    if(square_b == square_a + square_c) return 1;
    if(square_c == square_a + square_b) return 1;
    return 0;
}

int main(void){
    printf("%d\n", check(3,4,5));
    printf("%d\n", check(4,5,6));
    printf("%d\n", check(6,7,8));
    printf("%d\n", check(30,40,50));
    return 0;
}