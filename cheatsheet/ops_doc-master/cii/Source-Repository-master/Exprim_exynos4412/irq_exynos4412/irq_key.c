#include "exynos_4412.h"
#include "debug.h"
#define LED_ON_TIMER 0xfffff
void delay(unsigned int x){
    unsigned int timer=x;
    while(timer--);
}
/* 57号中断(即EINT[9],按键K2，参考原理图和芯片手册中断号表)的中断处理*/
void irq57_handler(void){   
    deprint("irq57\n");
    GPX1.CON=GPX1.CON&(~(0xf<<0))|(0x1<<0); //配置LED3的相应管脚(GPX1_1)为输出
    GPX1.DAT|=(0x1<<0);                     //GPX1_1输出高电平
    delay(LED_ON_TIMER);                    //延时
    GPX1.DAT&=~(0x1<<0);                    //GPX1_1输出低电平
}
void irq58_handler(void){
    deprint("irq58\n");
    GPF3.CON=GPX2.CON&(~(0xf)<<16)|(0x1<<16);
    GPF3.DAT|=(0x1<<4);
    delay(LED_ON_TIMER);
    GPF3.DAT&=~(0x1<<4);
}
void do_irq(void){      //irq入口函数
    //ICCIAR的低10位是当前触发的中断号
    volatile unsigned int IRQ_ID=CPU0.ICCIAR & 0x3ff;  
    switch (IRQ_ID){
    case 57:
        irq57_handler();

        //处理完中断应该将相应的中断标志清除，
        //否则GIC会认为中断没有响应，继续给CPU发送这个中断
        //  EXT_INT41_PEND=EXT_INT41_PEND|(0x1<<1);
        //  BUG!!!，写一置零，如果低位本来是1,会将其一起清零！！！
        EXT_INT41_PEND=0x2; 
        break;
    case 58:
        irq58_handler();
        EXT_INT41_PEND=0x4;
        break;
    default:
        break;
    }
    deprint("switch over\n");
    //将中断号告诉GIC，表示中断处理完毕，可以将下一个pending的中断送入
    CPU0.ICCEOIR = CPU0.ICCEOIR & (~(0x3ff))|IRQ_ID;    
}


int main()
{
    //外设配置
    //1. 将GPX1_1 GPX1_2 设置为中断功能GPX1CON
    GPX1.CON=GPX1.CON|(0xff<<4);
    detobin(GPX1.CON);
        
    //2. 设置GPX1_1 GPX1_2的触发方式为下降沿触发
    EXT_INT41_CON=EXT_INT41_CON|(0x22);
    detobin(EXT_INT41_CON);

    //3. 使能GPX1_1 GPX1_2中断
    EXT_INT41_MASK=EXT_INT41_MASK&(~(0x3<<1));
    detobin(EXT_INT41_MASK);

    //GIC配置
    //4. 全局使能GIC使其可以监控外设的中断信号并转发到CPU接口
    ICDDCR=1;
    detobin(ICDDCR);
    //5. 在中断管理器中使能57,58号中断，ICDISER1[25]
    ICDISER.ICDISER1=ICDISER.ICDISER1|(0x3<<25);
    detobin(ICDISER.ICDISER1);  

    //6. 给57 58号中断选择一个目标CPU。这里选CPU0 ICDIPTR14[23:16][15:8]
    ICDIPTR.ICDIPTR14=ICDIPTR.ICDIPTR14|(0x1<<16)|(0x1<<8); 
    detobin(ICDIPTR.ICDIPTR14);

    //CPU配置
    //7. 使能全局中断信号开关，使中断能够通过相应接口到达处理器，这里是CPU0 
    CPU0.ICCICR=1;  
    detobin(CPU0.ICCICR);

    //8. 优先级低于ICCPMR的中断才能被送入cpu，
    //这里使所有的中断都能够经过CPU0接口到达处理器，给255。
    CPU0.ICCPMR=0xff;
    detobin(CPU0.ICCPMR);
    while(1);

    return 0;
}
