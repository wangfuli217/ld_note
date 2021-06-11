#include "uart.h"
#include "irq.h"
#include "led.h"

void c_swi_handler(void)
{
    uart_puts("\nc_swi_handler\n");
    while(1)
    {
        ;
    }
}

void c_und_handler(void)
{
    uart_puts("\nc_und_handler\n");
    while(1)
    {
        ;
    }
}

void c_pabt_handler(void)
{
    uart_puts("\nc_pabt_handler\n");
    while(1)
    {
        ;
    }
}

void c_dabt_handler(void)
{
    uart_puts("\nc_dabt_handler\n");
    while(1)
    {
        ;
    }
}

void c_fiq_handler(void)
{
    uart_puts("\n c_fiq_handler \n");
}


//第一次要执行的中断处理函数
//自定义新的数据类型叫irq_func_t，本质就是函数指针
typedef void (*irq_func_t)(void);

//后续的中断处理函数
void exint0_func(void)
{
    uart_puts("\n exint0_func \n");
    led1_on();
    EXINT0PEND |= 1; //清中断
}

void c_irq_handler(void)
{
    uart_puts("\n c_irq_handler \n");
    //1.明确之前由汇编已经做好了保存现场的工作
    //2.此中断处理函数执行完毕,恢复现场也是由汇编来实现
    //后续的中断处理函数就是exint0_func
    irq_func_t func; //定义一个函数指针变量
    //取出函数地址(此时此刻是个数)
    func = (irq_func_t)VIC0ADDRESS;
    if (func)
        func(); //调用，最终调用exint0_func
    VIC0ADDRESS=0; //清中断
}

void irq_init(void)
{
    //中断源配置
    //1.关闭中断
    EXINT0MASK = 0xFFFFFFFF;
    //2.清除中断标志
    EXINT0PEND = 0xFFFFFFFF;
    //3.配置GPH0_0管脚为外部中断0，即XEINT0
    GPH0CFG |= 0xF;
    //4.禁止该管脚的上下拉电阻
    GPH0PUD &= ~0x3;
    //5.中断触发方式为下降沿触发
    EXINT0CON = (EXINT0CON & (~7)) | 0x2;
    //6.禁止滤波
    EXINT0FLT = 0;

    //中断控制器的配置
    //1.关中断
    VIC0INTCLEAR |= 1;
    //3.VICSELECT IRQ选择
    VIC0INTSELECT = 0;
    //4.VIC0ADDRESS=0(一组只有一个)
    //最终执行此寄存器中的中断处理函数
    VIC0ADDRESS = 0;
    //5.VIC0VECTADDR0=func(每个中断源都有一个，完成中断处理程序的注册)
    //一旦硬件触发中断，CPU自动将VIC0VECTADDR0里的内容拷贝到
    //VIC0ADDRESS里面
    VIC0VECTADDR0 = (unsigned int)exint0_func;
    
    //开中断
    //1.开中断源的中断
    EXINT0MASK &= ~1;
    //2.开中断控制器的中断
    VIC0INTENABLE |= 1;
    //3.开ARM核的中断响应位CPSR
    enable_irq();
}












