#include "uart.h"

#define NFCONF  *((volatile unsigned long *)0xB0E00000)
#define NFCONT  *((volatile unsigned long *)0xB0E00004)
#define NFCMMD  *((volatile unsigned char *)0xB0E00008)
#define NFADDR  *((volatile unsigned char *)0xB0E0000C)
#define NFDATA  *((volatile unsigned char *)0xB0E00010)
#define NFSTAT  *((volatile unsigned long *)0xB0E00028)

//100 = 0x64
//目标：0x64 -> "0x64"输出

//将整型数按照16进制的字符串形式转换
//buf保存转换以后的字符串，num：要转换的整型数
//1.先将数转成对应的16进制数
//2.对16进制数进行解析，获取对应的字符
//例如：0x1234567A "0x1234567A"
//      0xEC       "0x000000EC"
//                  0123456789 //下标
//buf缓冲区的大小11字节:buf[0] = '0', buf[1] = 'x'...
void itoa(char *buf, unsigned int num)
{
    int i = 9;
    char c = 4; 
    
    buf[0] = '0';
    buf[1] = 'x';

    //'0~9' 'A~F'
    while(num) {
        c = num % 16; //求余
        if (c > 9)
            buf[i] = 'A' + c - 10;
        else
            buf[i] = '0' + c;
        
        num = num / 16; //求商
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
    //1.配置配置寄存器
    //TACLS=0:表示CLE和ALE使能多久以后再使能WE
    //TWRPH0=2：表示WE信号的宽度
    //TWRPH1=1：表示WE无效多久以后再无效ALE或者CLE
    //具体对比两个手册的时序图
    NFCONF = (0 << 12) | (2 << 8) | (1 << 4) | (1 << 1);

    //2.配置控制寄存器
    //使能NAND控制器
    //片选使用的时候在拉低
    NFCONT = (1 << 0);
    //3.GPIO复用,要配置GPIO为nand功能:此事不做,因为uboot已经完成
}

void nand_read_id(void)
{
    unsigned char id[5]; //存放ID信息
    int i;
    char buf[11] = {0};

    //1.使能片选
    //bit[1] = 0
    NFCONT &= ~(1 << 1);

    //2.发送命令0x90
    NFCMMD = 0x90;

    //3.发送地址0x00
    NFADDR = 0x00;

    //4.延时
    for (i = 0; i < 1000; i++);

    //5.读ID信息,读5次
    for (i = 0; i < 5; i++) {
        id[i] = NFDATA;
    }

    //6.记得关闭片选
    NFCONT |= (1 << 1);

    //7.打印输出ID信息
    //0xEC -> "0xEC"
    for (i = 0; i < 5; i++) {
         itoa(buf, id[i]); //转换
         uart_puts(buf);
         uart_puts("\n\r");
    }
}

#define PAGE_SIZE   (2048)
//buf:表示存放数据的缓冲区buf[i]
void nand_read_page(unsigned char *buf,
                    unsigned int addr)
{
    int page_no = addr/PAGE_SIZE; //8000/2048
    int page_offset = addr%PAGE_SIZE; //1856 = 0x740
    int i;

    //1.使能片选
    NFCONT &= ~(1 << 1);
    
    //2.发送命令0x00
    NFCMMD = 0x00;

    //3.发送列地址
    NFADDR = page_offset & 0xff;
    NFADDR = (page_offset >> 8) & 0x0f;
    //4.发送行地址
    NFADDR = page_no & 0xff;
    NFADDR = (page_no >> 8) & 0xff;
    NFADDR = (page_no >> 16) & 0x07;

    //5.发送命令0x30
    NFCMMD = 0x30;
    
    //6.判断Nand的状态:闲了就读；忙就死等
    //BIT[0]=0:忙;BIT[0]=1:闲
    while(!(NFSTAT & (1 << 0)));

    //7.读取Nand的数据到buf缓冲区,读1页
    for (i = 0; i < PAGE_SIZE; i++) 
        buf[i] = NFDATA;

    //8.禁止片选
    NFCONT |= (1 << 1);
}






















