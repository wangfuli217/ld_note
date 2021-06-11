/*定义相关寄存器*/
#define ULCON0 *((volatile unsigned long *)0xE2900000)
#define UCON0 *((volatile unsigned long *)0xE2900004)
#define UTRSTAT0 *((volatile unsigned long *)0xE2900010)
#define UTXH0 *((volatile unsigned long *)0xE2900020)
#define URXH0 *((volatile unsigned long *)0xE2900024)
#define UBRDIV0 *((volatile unsigned long *)0xE2900028)
#define UDIVSLOT0 *((volatile unsigned long *)0xE290002C)

#define GPA0CON *((volatile unsigned long *)0xE0200000)
#define GPA0PUD *((volatile unsigned long *)0xE0200008)

//初始化函数定义
void uart_init(void)
{
    //1.配置TX/RX两个管教为UART专有IO口
    //禁止上下拉功能
    GPA0CON &= ~(0xff << 0);
    GPA0CON |= (0x22 << 0);
    GPA0PUD &= ~(0xf << 0);
    
    //2.配置UART0的工作参数：115200 8n1
    //一旦初始化完毕,UART0就可以操作使用
    ULCON0 = 0x3; //8n1
    ULCON0 = 0x3; //8n1
    UCON0 = 0x5; //采用轮训
    UBRDIV0=35; //(66500000/(115200*16))-1
    UDIVSLOT0=0x0080;
}

//发送字符函数定义
void uart_putc(char c)
{
    //1.先判断发送缓冲区是否为空
    //  如果为空,将数据写到发送缓冲区
    //  如果不为空,死等直到发送缓冲区为空
    while(!(UTRSTAT0 & 0x2));

    //2.将数据写到发送缓冲区寄存器
    UTXH0 = c;
    
    if (c == '\n') 
        uart_putc('\r');
}

//发送字符串函数定义
//char *s = "hello,world\n"
//uart_puts(s);
void uart_puts(char *s)
{
    while(*s) {
        uart_putc(*s);
        s++;
    }
}

//字符接收函数定义
char uart_getc(void)
{
    //1.判断接收缓冲区是否有数据
    // 如果有数据,那就读
    // 如果没有数据,那就死等,直到缓冲区有数据

    while(!(UTRSTAT0 & 0x1));
    
    //读取并返回缓冲区的数据
    return (char)(URXH0 & 0xff);
}

//字符串接收函数定义
//调用：char buf[32]; uart_gets(buf, 32);
void uart_gets(char *buf, int len)
{
    int i = 0;
    char tmp = 0;

    while(i < (len - 1)) {
        tmp = uart_getc();
        uart_putc(tmp); //回显
        buf[i] = tmp;
        if (tmp == '\r') //处理回车
            break;
        i++;
    }
    buf[i] = '\0';     
}







































