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


void c_irq_handler(void)
{
    uart_puts("\n c_irq_handler \n");
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
    VIC0ADDRESS = 0;
    //5.VIC0VECTADDR0=func(每个中断源都有一个，完成中断处理程序的注册)
    //VIC0VECTADDR0 = (unsigned int)exint0_func;
    
    //开中断
    //1.开中断源的中断
    EXINT0MASK &= ~1;
    //2.开中断控制器的中断
    VIC0INTENABLE |= 1;
    //3.开ARM核的中断响应位CPSR
    enable_irq();
}












