#include <stdio.h>

/*
右移，高位补符号位（少数机器高位补零）
左移，右侧空位补零，左侧符号位移出，原先的某数据位将成为符号位（少数机器符号位被固定，是不能位移的）
*/
int main(void){
    char ch = 127;
    char ret = ch << 1;
    printf("result: %d\n", ret); /* -2 */

    ch = -65;
    ret = ch << 1;
    printf("result: %d\n", ret); /* 126 */

    return 0;
}