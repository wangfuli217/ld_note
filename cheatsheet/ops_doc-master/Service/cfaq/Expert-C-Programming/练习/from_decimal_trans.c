#include <stdio.h>
#include <string.h>

// 十进制转任意进制
char alpha(int num){
    if (num < 10) return '0' + num;/* 0~9 */
    return (num - 10) + 'A'; /* A~F */
}

int trans(int num, int radix, char *out_data){
    if (num == 0) return 0;
    int idx = trans(num / radix, radix, out_data);
    printf("idx=%d num=%d\n", idx, num);
    out_data[idx] = alpha(num % radix);
    return idx + 1;
}

int main(void){
    int num = 78;
    char data[100] = {0};

    trans(num, 2, data);
    printf("bin: %s\n", data);

    memset(data, 0, 100);
    trans(num, 8, data);
    printf("oct: %s\n", data);

    memset(data, 0, 100);
    trans(num, 16, data);
    printf("hex: %s\n", data);

    memset(data, 0, 100);
    trans(num, 10, data);
    printf("den: %s\n", data);
    return 0;
}