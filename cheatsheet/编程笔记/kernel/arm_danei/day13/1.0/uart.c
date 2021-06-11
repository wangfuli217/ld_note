//定义相关寄存器的地址信息
#define ULCON0  *((volatile unsigned long *)0xE2900000)
#define UCON0  *((volatile unsigned long *)0xE2900004)
#define UFCON0  *((volatile unsigned long *)0xE2900008)
#define UTRSTAT0  *((volatile unsigned long *)0xE2900010)
#define UTXH0  *((volatile unsigned long *)0xE2900020)
#define URXH0  *((volatile unsigned long *)0xE2900024)
#define UBRDIV0  *((volatile unsigned long *)0xE2900028)
#define UDIVSLOT0  *((volatile unsigned long *)0xE290002C)

#define GPA0CON  *((volatile unsigned long *)0xE0200000)
#define GPA0PUD  *((volatile unsigned long *)0xE0200008)

#define PCLK  66500000 //66.5MHz
#define SPEED   115200 //波特率

//函数定义
void uart_init(void)
{
    //1.配置GPA0_0,GPA0_1为UART功能，禁止上下拉
    GPA0CON &= ~(0xff << 0);
    GPA0CON |= (0x22 << 0);
    GPA0PUD &= ~(0xf << 0);

    //2.配置UART的工作参数：115200,8n1
    //一旦初始化完毕,接下来可以进行收发数据
    ULCON0 = 0x3;
    UCON0 = 0x5;
    UFCON0 = 0;
    UBRDIV0=(PCLK/(SPEED*16)) - 1;
    UDIVSLOT0=0x0080;
}
void uart_putc(char c)
{
    //通过察看状态寄存器先判断发送缓冲区是否为空
    //BIT[1] = 1:空；BIT[1] = 0:非空
    //如果没有发送完毕,CPU死等
    while(!(UTRSTAT0 & 0x2));
    //将数据放到发送缓冲区
    UTXH0 = c;
    if (c == '\n')
        uart_putc('\r');
}
//char *s = "helloworld\n"
void uart_puts(char *s)
{
    while(*s) {
        uart_putc(*s);
        s++;
    }
}

//TPAD接收字符
char uart_getc(void)
{
    //1.判断接收缓冲区是否有数据
    //状态寄存器的BIT[0]=1:有；=0：无
    //没有数据，CPU进入死等
    while(!(UTRSTAT0 & 0x1));
    return (char)(URXH0 & 0xff);
}

//TPAD接收字符串
//调用例子：char buf[32];uart_gets(buf, 32);
//char buf[32] = "hello,world";
void uart_gets(char *buf, int len)
{
    int i = 0;
    char tmp = 0;
    while(i < (len - 1)) {
        tmp = uart_getc(); //TPAD读字符  
        
        if (!(tmp == 0x08 && i == 0))
            uart_putc(tmp); //TPAD将字符再发PC(回显)
        else
            continue;

        buf[i] = tmp; 
        if (tmp == '\r') //响应回车
            break;
        
        //回退处理
        if (tmp == 0x08) {
            uart_putc(0x20); //空格
            uart_putc(0x08); //回退
            i--;
            continue;
        }
        i++;
    }
    buf[i] = '\0';
}





















