#include "uart.h"

static char buf[32];

void main(void)
{
    //1.初始化串口
    uart_init();

    //2.循环发送字符串给PC
    while(1) {
        uart_puts("\n Please input string:\n");
        uart_gets(buf, 32);
        uart_puts("\n you input string:");
        uart_puts(buf);
    }
}
