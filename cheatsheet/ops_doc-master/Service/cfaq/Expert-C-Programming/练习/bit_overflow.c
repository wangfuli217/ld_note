//位运算
//a^=b; b^=a; a^=b; 可以实现不用第三个临时变量来交换值
#include <stdio.h>

int main(void){
	int i = 0x01 << 2 + 3; // 32 , 算术运算优先级高
	int j = 0x01 << 2 + 32; // 0 , 溢出
	int k = 0x01 << 2 - 3; // 0 
	int l = 0x01 >> 2 - 3; // 0 不能为负数
	int m = 0x01 << 2; // 4
    printf("i=%d j=%d k=%d l=%d m=%d\n", i, j, k, l, m);
    return 0;
}