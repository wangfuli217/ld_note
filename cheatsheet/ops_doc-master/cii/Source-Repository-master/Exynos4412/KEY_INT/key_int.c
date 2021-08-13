#include "exynos_4412.h"

/*****通过轮询方式检测按键*****/
#if 0
void main(void)
{
	/*将GPX1_1设置成输入功能*/
	GPX1.CON = GPX1.CON & (~(0xF << 4));
	/*将GPX2_7管脚设置成输出功能*/
	GPX2.CON = GPX2.CON & (~(0xf << 28)) | (1 << 28);

	while(1)
	{
		/*GPX1_1引脚为高电平*/
		if(GPX1.DAT & (1 << 1))
			/*LED亮*/
			GPX2.DAT = GPX2.DAT | (1 << 7);
		/*GPX1_1引脚为低电平*/
		else
			/*LED灭*/
			GPX2.DAT = GPX2.DAT & (~(1 << 7));
	}
}
#endif

/*****通过中断方式检测按键*****/

//使用中断需要设置三个层次
//1.外设层次，打开外设层次的中断功能使中断能够到达中断管理器
//2.GIC层次，设置优先级，目标CPU，管理挂起状态等
//3.CPU层次,中断优先级屏蔽等功能

//中断管理器：统一管理中断主要涉及中断优先级，中断挂起，中断交给哪个CPU去处理等问题

/*****1.实验目的：通过中断方式检测按键是否按下并在中断服务函数中写处理函数*****/

/*****2.实验步骤：查找电路图找出按键与处理器的哪个管脚相连*****/

unsigned int Num;

void do_irq(void)
{
	unsigned int irq_num;

	/*去GIC中读取当前中断的中断号,同时GIC中将对应的中断标为正在执行的状态*/
	irq_num = CPU0.ICCIAR & 0x3FF;

	/*判断是哪个中断然后进行相应的中断服务*/
	switch(irq_num)
	{
		case 57:
			Num ++;
			if(Num % 2)
				GPX2.DAT = GPX2.DAT | (1 << 7);
			else
				GPX2.DAT = GPX2.DAT & (~(1 << 7));

			/*将外设层次的中断挂起标志位清除  写1清0*/
			EXT_INT41_PEND = 0x2;
			/*将GIC层次中57号中断的中断挂起标志位清零  写1清0*/
			ICDICPR.ICDICPR1 = 0x2000000;
			break;
		case 58:
			break;
		case 59:
			break;
		default:
			break;
	}
	/*将中断号写回到GIC通知GIC可以将新的中断送入到处理器*/
	CPU0.ICCEOIR = CPU0.ICCEOIR & (~(0X3FF << 0)) | irq_num;
}

void main(void)
{
	/*****外设层次*****/
	/*1.将GPX1_1管脚设置成中断功能*/
	GPX1.CON = GPX1.CON | (0xF << 4);
	/*2.设置GPX1_1管脚中断触发方式为下降沿触发*/
	EXT_INT41_CON = EXT_INT41_CON & (~(0x7 << 4)) | (0x2 << 4);
	/*3.使能GPX1_1管脚的中断使其能够顺利到达GIC中断控制器*/
	EXT_INT41_MASK =  EXT_INT41_MASK & (~(1 << 1));

	/*****CPU层次*****/
	/*4.全局使能中断信号能够通过相应的CPU接口到达相应的处理器ICCICR_CPU0，每个CPU对应一个相应的寄存器*/
	CPU0.ICCICR = CPU0.ICCICR | 1;
	/*5.设置中断优先级屏蔽寄存器ICCPMR_CPU0，使所有的中断都能通过CUP接口到达处理器*/
	CPU0.ICCPMR = CPU0.ICCPMR | 0xFF;

	/*****GIC层次*****/
	/*6.全局使能GIC使GIC的信号能到达CPU接口 ICDDCR*/
	ICDDCR = ICDDCR | 1;
	/*7.在中断管理器中打开相应的位使能GPX1_1管脚的中断（57）ICDISER*/
	ICDISER.ICDISER1 = ICDISER.ICDISER1 | (1 << 25);
	/*8.将57号中断指定给对应的处理器去处理ICDIPTR*/
	ICDIPTR.ICDIPTR14 = ICDIPTR.ICDIPTR14 & (~(0xFF << 8)) | (0x1 << 8);

	/*将GPX2_7管脚设置成输出功能*/
	GPX2.CON = GPX2.CON & (~(0xf << 28)) | (1 << 28);

	while(1)
	{

	}
}
