#include "uart.h"

/*寄存器*/
#define NFCONF  *((volatile unsigned long *)0xB0E00000)
#define NFCONT  *((volatile unsigned long *)0xB0E00004)
#define NFCMMD  *((volatile unsigned char *)0xB0E00008)
#define NFADDR  *((volatile unsigned char *)0xB0E0000C)
#define NFDATA  *((volatile unsigned char *)0xB0E00010)
#define NFSTAT  *((volatile unsigned long *)0xB0E00028)

//整形转对应字符串函数定义
//0x123456AB->"0x123456AB"
//  数组下标   0123456789
//调用：char buf[11];itoa(buf, 100)
//100->0x00000064
void itoa(char *buf, unsigned int num)
{
    int i = 9;  
    char c = 0;
    buf[0] = '0';
    buf[1] = 'x';

    //0~9 A~F
    while(num) {
        c = num % 16; //求余 4 -> '4'
        if (c > 9)
            buf[i] = 'A' + c - 10;
        else
            buf[i] = '0' + c;
        
        num = num / 16;
        i--;
    }
    
    while(i >= 2) {
        buf[i] = '0';
        i--;
    }

    buf[10] = 0; //结束
}

void nand_init(void)
{
    //1.配置Nand控制寄存器
    NFCONF = 
        (0 << 12) | (2 << 8) | (1 << 4) | (1 << 1);
    
    //2.使能Nand控制器
    //注意：千万现在不要使能片选
    NFCONT = (1 << 0);
}

void nand_read_id(void)
{
    unsigned char id[5] = {0}; //存放ID信息
    int i;
    char buf[11];

    //1.使能片选
    NFCONT &= ~(1 << 1);

    //2.发送命令0x90
    NFCMMD = 0x90;

    //3.发送地址0x00
    NFADDR = 0x00;

    //延时
    for (i =0; i < 1000; i++);

    //4.读取ID数据
    for (i = 0; i < 5; i++) {
        id[i] = NFDATA;
    }
    //5.打印
    //需要调用一个函数：0xEC->"0xEC"
    for (i = 0; i < 5; i++) {
        itoa(buf, id[i]);
        uart_puts(buf);
        uart_puts("\n\r");
    } 
    //6.禁止片选
    NFCONT |= (1 << 1);
}







