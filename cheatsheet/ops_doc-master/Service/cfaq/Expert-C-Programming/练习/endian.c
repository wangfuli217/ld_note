#include <stdio.h>
union data{
    short inter;
    char ch;
};

int main(void)
{
    union data c;
    c.inter = 0x1122;
    if(c.ch == 0x22)
        printf("The compute is little-endian(Intel,AMD).\n");
    else
        printf("The compute is big-endian(ARM),\n");
}
/*
    大尾存储就是最重要的数存在前部(低位)，即数据的高位，保存在内存的低地址中
(地址的增长顺序与值的增长顺序相反)。一双字87654321H，则大尾存储就是 87H 65H 43H 21H ，
存储地址递增，判断当前系统大小尾
*/
#if 0
#include <stdio.h>


int main(int argc, const char *argv[]){
    int hoge = 0x12345678;
    unsigned char *hoge_p = (unsigned char*)&hoge;

    printf("%x\n", hoge_p[0]);
    printf("%x\n", hoge_p[1]);
    printf("%x\n", hoge_p[2]);
    printf("%x\n", hoge_p[3]);

    return 0;
}
/* 
输出78 56 34 12的，这种配置方式称为小端字节序(little-endian)，Intel,AMD均属于此类
*/

#endif