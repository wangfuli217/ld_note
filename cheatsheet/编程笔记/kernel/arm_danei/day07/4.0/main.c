#include "uart.h"
#include "led.h"
#include "cmd.h"

static char buf[32];

void main(void)
{
    //1.初始化串口
    uart_init();
    //2.初始化LED
    led_init();

    //2.循环发送字符串给PC
    while(1) {
        uart_puts("\n Please input string:\n");
        uart_gets(buf, 32);
        if (!my_strcmp(buf, "ledon"))
                led_on(); //开
        else if(!my_strcmp(buf, "ledoff"))
                led_off();//关
    }
}
