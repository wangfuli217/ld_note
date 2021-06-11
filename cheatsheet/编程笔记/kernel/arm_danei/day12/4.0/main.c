#include "uart.h"
#include "led.h"
#include "cmd.h"
#include "nand.h"

static char buf[32];
static cmd_t *cmd; //指向某个命令对象
void main(void)
{
    //1.初始化串口
    uart_init();
    //2.初始化LED
    led_init();
    //3.初始化nand
    nand_init();

    //2.循环发送字符串给PC
    while(1) {
        uart_puts("\n armshell#");
        uart_gets(buf, 32);
        cmd = find_cmd(buf); //根据命令名找命令对象
        if (cmd == 0)
            uart_puts("命令不对!\n");
        else
            cmd->cmd_func(); //调用命令对应的函数 
    }
}
