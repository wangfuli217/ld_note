#include "uart.h"
#include "cmd.h"
#include "led.h"

static char buf[32];

//go 20004000->ldr pc, _reset->reset->main
int main(void)
{
    //1.初始化串口,LED,中断
    uart_init();
    led_init();
    irq_init(); //一旦初始化完毕,就可以操作KEY1_UP

    cmd_t *cmd; //定义命令对象
    //2.循环等待用户进行输入命令
    while(1) {
        uart_puts("\n armshell#"); //打印提示符
        uart_gets(buf, 32);//等待用户输入命令
        
        //如果用户输入exit，退出程序
        if(my_strcmp(buf, "exit") == 0)
            return 0;
        
        cmd = find_cmd(buf);//根据输入命令找到对应                              的命令对象
        if (cmd == 0) //没有找到
            uart_puts("\n this cmd is invaild");
        else    //找到
            cmd->cmd_func(); //调用对应的硬件操作                                 函数
    }

    return 0;
}





