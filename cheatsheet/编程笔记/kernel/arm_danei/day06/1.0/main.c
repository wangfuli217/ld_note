#include "uart.h"

void main(void)
{
    //1.初始化串口
    uart_init();

    //2.循环发送字符串给PC
    while(1) {
        uart_puts("hello,world!\n");
    }
}
